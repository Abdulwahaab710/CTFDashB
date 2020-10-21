# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :return_not_found_if_challenge_is_not_active, only: :create
  before_action :return_forbidden_if_reached_max_tries, only: :create
  before_action :return_forbidden_if_submitted_valid_flag_before, only: :create

  include Submissions
  include ActionView::Helpers::DateHelper

  def create
    @challenge = challenge
    return head 404 if @challenge.nil?
    return invalid_flag unless validate_flag_format(submitted_flag)

    add_submission
    verify_flag
  end

  private

  def verify_flag
    if FlagVerifier.new(@challenge, submitted_flag).call
      successful_submission
    else
      unsuccessful_submission
    end
  end

  def successful_submission
    @submission&.update(valid_submission: true)
    update_score
    render_alert
  end

  def render_alert
    @message = @challenge.after_message
    flash.now[:success] = 'Woohoo, you have successfully submitted your flag'
    respond_to do |f|
      f.js { render 'successful_submission', status: :ok }
    end
  end

  def unsuccessful_submission
    flash.now[:danger] = 'Flag is incorrect'
    @max_tries = remaining_tries
    @submission&.update(valid_submission: false, flag: submitted_flag)
    respond_to do |f|
      f.js { render 'unsuccessful_submission', status: :unprocessable_entity }
    end
  end

  def invalid_flag
    flash.now[:danger] = 'Invalid flag format'
    respond_to do |f|
      f.js { render 'unsuccessful_submission', status: :unprocessable_entity }
    end
  end

  def build_submission_signature
    salt = Rails.application.secrets.submission_salt
    Digest::SHA256.hexdigest("#{@challenge.id}-#{current_user&.team&.id}-#{submitted_flag}-#{salt}")
  end

  def submitted_flag
    params.require(:submission).permit(:flag)[:flag]
  end

  def update_score
    return if current_user.organizer?

    old_scores = Team.order(score: :desc).first(3).pluck(:name, :score)

    current_user.team.update(score: calculate_team_new_score)

    new_scores = Team.order(score: :desc).pluck(:name, :score)
    if CtfSetting.scoreboard_enabled?
      message = {
        scoreboard: new_scores,
        submission: {
          team: { id: @submission.team.id, name: @submission.team.name },
          challenge: { id: @submission.challenge.id, title: @submission.challenge.title },
          category: { id: @submission.category.id },
          created_at: time_ago_in_words(@submission.created_at)
        },
        confetti_message: confetti_message(old_scores, new_scores)
      }
      ActionCable.server.broadcast 'scores_channel', message: message.to_json
    end
  end

  def confetti_message(old_scores, new_scores)
    old_scores = old_scores.map { |s| s[0] }
    new_scores = new_scores.map { |s| s[0] }
    return nil if old_scores == new_scores.first(3)

    "#{@submission.team.name} Leveled up" if new_scores.include?(@submission.team.name)
  end

  def calculate_team_new_score
    Submission.where(team: current_user.team, valid_submission: true).map { |s| s.challenge.points }.sum
  end

  def challenge
    @challenge ||= Challenge.find_by(id: params[:id], category_id: params[:category_id], active: true)
  end

  def reached_the_max_number_of_tries?
    number_of_tries.to_i >= challenge&.max_tries
  end

  def remaining_tries
    challenge&.max_tries.to_i - number_of_tries
  end

  def number_of_tries
    challenge&.submissions&.where(team: current_user&.team)&.count
  end

  def return_forbidden_if_reached_max_tries
    return true unless reached_the_max_number_of_tries?

    flash.now[:danger] = 'You have reached the maximum number of tries.'
    respond_to do |f|
      f.js { render 'forbidden_submission', status: :forbidden }
    end
  end

  def return_not_found_if_challenge_is_not_active
    return true unless challenge.nil?

    flash.now[:danger] = 'Challenge was not found'
    respond_to do |f|
      f.js { render 'forbidden_submission', status: :not_found }
    end
  end
end

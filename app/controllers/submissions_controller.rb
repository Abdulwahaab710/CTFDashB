# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :return_forbidden_if_reached_max_tries, only: :create
  before_action :return_forbidden_if_submitted_valid_flag_before, only: :create

  include Submissions

  def create
    @challenge = challenge
    return head 404 if @challenge.nil?
    return invalid_flag unless validate_flag_format(submitted_flag)
    add_submission
    verify_flag
  end

  private

  def verify_flag
    if flag.is_password?(submitted_flag)
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
    Digest::SHA256.hexdigest("#{@challenge.id}#{current_user&.team&.id}#{submitted_flag}#{salt}")
  end

  def submitted_flag
    params.require(:submission).permit(:flag)[:flag]
  end

  def update_score
    return if current_user.organizer?
    score = Submission.where(team: current_user.team, valid_submission: true).map { |s| s.challenge.points }.sum
    current_user.team.update(score: score)
  end

  def flag
    @flag ||= BCrypt::Password.new(@challenge&.flag)
  end

  def challenge
    return @challenge ||= all_challenges if current_user.organizer?
    @challenge ||= active_challenges
  end

  def reached_the_max_number_of_tries?
    number_of_tries >= challenge&.max_tries
  end

  def remaining_tries
    challenge&.max_tries.to_i - number_of_tries
  end

  def number_of_tries
    challenge&.submissions&.where(team: current_user&.team)&.count.to_i
  end

  def return_forbidden_if_reached_max_tries
    return true unless reached_the_max_number_of_tries?
    flash.now[:danger] = 'You have reached the maximum number of tries.'
    respond_to do |f|
      f.js { render 'forbidden_submission', status: :forbidden }
    end
  end

  def category
    @category ||= Category.find_by(id: params[:category_id])
  end

  def all_challenges
    category&.challenges&.find_by(id: params[:id])
  end

  def active_challenges
    category&.challenges&.where(active: true)&.find_by(id: params[:id])
  end
end

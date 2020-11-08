# frozen_string_literal: true

module Submissions
  include ActionView::Helpers::DateHelper

  private

  def validate_flag_format(flag)
    return true unless flag_regex
    flag =~ Regexp.new(flag_regex)
  end

  def add_submission
    return nil if current_user.organizer?
    @submission = Submission.find_or_create_by!(
      team: current_user.team,
      user: current_user,
      category: @challenge.category,
      challenge: @challenge,
      submission_hash: build_submission_signature
    )
  end

  def return_forbidden_if_submitted_valid_flag_before
    return head :forbidden if submitted_valid_flag_before?
  end

  def submitted_valid_flag_before?
    !Submission.where(
      team: current_user.team, challenge: challenge, category: challenge.category, valid_submission: true
    ).empty?
  end

  def successful_submission
    @submission&.update(valid_submission: true)
    update_score_and_last_valid_submission_at
    render_alert
  end

  def invalid_format_flag
    render json: { error: 'Invalid flag format' }, status: :unprocessable_entity
  end

  def incorrect_flag
    render json: { error: 'Flag is incorrect', max_tries: @max_tries }, status: :unprocessable_entity
  end

  def render_alert
    @message = @challenge.after_message
    render json: { flash: 'Woohoo, you have successfully submitted your flag', message: @challenge.after_message }
  end

  def update_score_and_last_valid_submission_at
    return if current_user.organizer?

    old_scores = Team.order(score: :desc, last_valid_submission_at: :asc).first(3).pluck(:name, :score)

    current_user.team.update(score: calculate_team_new_score, last_valid_submission_at: Time.zone.now)

    new_scores = Team.order(score: :desc, last_valid_submission_at: :asc).limit(25).pluck(:name, :score)
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

  def return_not_found_if_challenge_is_not_active
    return true unless challenge.nil?

    render json: { error: 'Challenge was not found' }, status: :not_found
  end

  def build_submission_signature
    salt = Rails.application.secrets.submission_salt
    Digest::SHA256.hexdigest("#{@challenge.id}-#{current_user&.team&.id}-#{submitted_flag}-#{salt}")
  end

  def flag_regex
    @flag_regex ||= CtfSetting.find_by(key: 'flag_regex')&.value
  end
end

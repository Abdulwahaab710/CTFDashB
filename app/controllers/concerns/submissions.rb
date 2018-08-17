# frozen_string_literal: true

module Submissions
  def validate_flag_format(flag)
    return true unless flag_regex
    flag =~ Regexp.new(flag_regex)
  end

  def add_submission
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

  private

  def flag_regex
    @flag_regex ||= CtfSetting.find_by(key: 'flag_regex')&.value
  end
end

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

  private

  def flag_regex
    @flag_regex ||= CtfSetting.find_by(key: 'flag_regex')&.value
  end
end

# frozen_string_literal: true

module Submissions
  def validate_flag_format(flag)
    return true unless flag_regex
    flag =~ Regexp.new(flag_regex)
  end

  private

  def flag_regex
    @flag_regex ||= CtfSetting.find_by(key: 'flag_regex')&.value
  end
end

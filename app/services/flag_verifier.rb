class FlagVerifier < ChallengeFlag

  BCRYPT_PREFIX = '$2a$'

  def initialize(challenge, submitted_flag)
    @challenge = challenge
    @submitted_flag = submitted_flag
  end

  def call
    if @challenge&.regex_flag?
      regex = Regexp.new(@challenge.flag, regex_options)
      regex === @submitted_flag
    else
      if @challenge&.flag&.start_with? BCRYPT_PREFIX
        BCrypt::Password.new(@challenge&.flag).is_password?(@submitted_flag)
      else
        ActiveSupport::SecurityUtils.secure_compare(@challenge&.flag, @submitted_flag)
      end
    end
  end

  private

  def regex_options
    return Regexp::IGNORECASE if @challenge.case_insensitive?
  end
end

class FlagHasher < ChallengeFlag
  def initialize(flag)
    @flag = flag
  end

  def call
    return @flag unless hash_challenge_flag?

    BCrypt::Password.create(@flag)
  end
end

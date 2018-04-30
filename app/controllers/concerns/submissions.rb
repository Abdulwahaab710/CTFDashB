module Submissions
  def hash_flag(flag)
    BCrypt::Password.create(flag)
  end
end

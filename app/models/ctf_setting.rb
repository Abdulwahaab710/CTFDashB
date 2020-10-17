# frozen_string_literal: true

class CtfSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  class << self
    def hash_challenge_flag?
      hash_flag = self.find_or_create_by!(key: 'hash_flag')
      hash_flag.update(value: 'true') if hash_flag&.value&.nil?

      hash_flag.value.downcase == "true"
    end
  end
end

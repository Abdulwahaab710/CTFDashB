# frozen_string_literal: true

class CtfSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  class << self
    def hash_challenge_flag?
      self.find_or_create_by!(key: 'hash_flag', value: 'true').value.downcase == "true"
    end
  end
end

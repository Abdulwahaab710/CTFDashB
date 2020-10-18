# frozen_string_literal: true

class CtfSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value_type, presence: true, inclusion: { in: %w(Boolean String Time) }
  validate  :valid_value_for_type?

  class << self
    def hash_challenge_flag?
      hash_flag = self.find_or_create_by!(key: 'hash_flag')
      hash_flag.update(value: 'true') if hash_flag.value.nil?

      hash_flag.value.downcase == "true"
    end
  end

  private

  def valid_value_for_type?
    case value_type
    when "Boolean"
      errors.add(:value, "can be only true or false") unless value == "true" || value == "false"
    end
  end
end

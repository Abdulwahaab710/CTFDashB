# frozen_string_literal: true

class CtfSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value_type, presence: true, inclusion: { in: %w(Boolean String Time) }
  validate  :valid_value_for_type?

  class << self
    def unlimited_retries?
      find_or_create_by_with_default_value(key: 'unlimited_retries', value_type: 'Boolean', default_value: 'true')
    end

    def default_max_tries
      find_or_create_by_with_default_value(key: 'default_max_tries', value_type: 'String', default_value: '100')
    end

    def hash_challenge_flag?
      find_or_create_by_with_default_value(key: 'hash_flag', value_type: 'Boolean', default_value: 'false')
    end

    def scoreboard_enabled?
      find_or_create_by_with_default_value(key: 'scoreboard', value_type: 'Boolean', default_value: 'true')
    end

    def find_or_create_by_with_default_value(key:, value_type:, default_value:)
      setting = self.find_or_initialize_by(key: key)
      setting.update(value_type: value_type, value: default_value) if setting.value.nil?

      return ActiveModel::Type::Boolean.new.cast(setting.value) if setting.value_type == 'Boolean'
      setting
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

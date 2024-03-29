# frozen_string_literal: true

# == Schema Information
#
# Table name: ctf_settings
#
#  id         :integer          not null, primary key
#  key        :string
#  value      :string
#  value_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CtfSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value_type, presence: true, inclusion: { in: %w(Boolean String Time) }
  validate  :valid_value_for_type?

  class << self
    def unlimited_retries?
      find_or_create_by_with_default_value(key: 'unlimited_retries', value_type: 'Boolean', default_value: 'false')
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

    def start_time
      find_or_create_by_with_default_value(key: 'start_time', value_type: 'Time', default_value: '')
    end

    def end_time
      find_or_create_by_with_default_value(key: 'end_time', value_type: 'Time', default_value: '')
    end

    def general_submission_enabled?
      find_or_create_by_with_default_value(key: 'general_submission', value_type: 'Boolean', default_value: 'true')
    end

    def find_or_create_by_with_default_value(key:, value_type:, default_value:)
      setting = self.find_or_initialize_by(key: key)
      setting.update(value_type: value_type, value: default_value) if setting.value.nil?

      case value_type
      when 'Boolean'
        ActiveModel::Type::Boolean.new.cast(setting.value)
      when 'Time'
        Time.zone.parse(setting.value)
      else
        setting.value
      end
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

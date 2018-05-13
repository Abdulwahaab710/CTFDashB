class CtfSetting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
end

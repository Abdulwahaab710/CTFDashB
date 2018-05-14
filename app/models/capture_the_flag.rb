# frozen_string_literal: true

class CaptureTheFlag < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :info, presence: true
  validates :max_teammates, presence: true
end

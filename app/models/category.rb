# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :challenges, dependent: :destroy

  validates :name, uniqueness: true
end

# frozen_string_literal: true

class Challenge < ApplicationRecord
  belongs_to :category

  validates :title, :description, :points, :max_tries, :category, :flag, presence: true
  validates :points, :max_tries, numericality: { greater_than_or_equal_to: 1 }
  validates :flag, uniqueness: true

  def flag=(flag)
    write_attribute(:flag, BCrypt::Password.create(flag))
  end
end

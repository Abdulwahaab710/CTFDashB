# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :challenge
  belongs_to :category

  validates :submission_hash, presence: true, uniqueness: true
  validates :user, :team, :challenge, :category, presence: true

  scope :valid, -> { where(valid_submission: true) }
end

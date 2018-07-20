# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :challenge
  belongs_to :category

  validates :submission_hash, presence: true, uniqueness: true
end

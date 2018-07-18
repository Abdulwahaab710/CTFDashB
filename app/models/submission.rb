# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :challenge
  belongs_to :category
end

# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :submissions, dependent: :nullify
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :invitation_token,
            uniqueness: { case_sensitive: false }

  include Tokenable

  def valid_submissions
    submissions.includes(:challenge, :category).valid_submissions
  end
end

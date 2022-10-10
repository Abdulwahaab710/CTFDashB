# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id                       :integer          not null, primary key
#  invitation_token         :string
#  last_valid_submission_at :datetime
#  name                     :string
#  score                    :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
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

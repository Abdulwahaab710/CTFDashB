# frozen_string_literal: true

# == Schema Information
#
# Table name: submissions
#
#  id               :bigint           not null, primary key
#  flag             :string
#  submission_hash  :string
#  valid_submission :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  category_id      :bigint
#  challenge_id     :bigint
#  team_id          :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_submissions_on_category_id   (category_id)
#  index_submissions_on_challenge_id  (challenge_id)
#  index_submissions_on_team_id       (team_id)
#  index_submissions_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (challenge_id => challenges.id)
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#
class Submission < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :challenge
  belongs_to :category

  validates :submission_hash, presence: true, uniqueness: true
  validates :user, :team, :challenge, :category, presence: true

  scope :valid_submissions, -> { where(valid_submission: true) }
end

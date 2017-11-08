class Team < ApplicationRecord
  has_many :users
  validates :name, presence: true,
            uniqueness: { case_sensitive: false }
  validates :invitation_token,
            presence: true,
            uniqueness: { case_sensitive: false }
end

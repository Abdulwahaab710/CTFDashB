class TeamMember < ApplicationRecord
  belongs_to :teams
  belongs_to :users
end

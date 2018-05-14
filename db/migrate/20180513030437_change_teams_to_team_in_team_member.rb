# frozen_string_literal: true

class ChangeTeamsToTeamInTeamMember < ActiveRecord::Migration[5.0]
  def change
    add_reference :team_members, :team, foreign_key: true
    add_reference :team_members, :user, foreign_key: true
    add_reference :ctf_points, :team, foreign_key: true
    add_reference :ctf_points, :user, foreign_key: true
  end
end

# frozen_string_literal: true

class ChangeTeamsToTeamInTeamMember < ActiveRecord::Migration[5.0]
  def change
    remove_column :team_members, :teams
    remove_column :team_members, :users
    remove_column :ctf_points, :teams
    remove_column :ctf_points, :users
    add_reference :team_members, :team, foreign_key: true
    add_reference :team_members, :user, foreign_key: true
    add_reference :ctf_points, :team, foreign_key: true
    add_reference :ctf_points, :user, foreign_key: true
  end
end

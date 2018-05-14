# frozen_string_literal: true

class RemoveTeamsFromTeamMembers < ActiveRecord::Migration[5.2]
  def change
    remove_column :team_members, :teams, :boolean
    remove_column :team_members, :users, :boolean
    remove_column :ctf_points, :teams, :boolean
    remove_column :ctf_points, :users, :boolean
  end
end

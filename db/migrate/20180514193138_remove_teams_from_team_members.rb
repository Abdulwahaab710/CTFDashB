# frozen_string_literal: true

class RemoveTeamsFromTeamMembers < ActiveRecord::Migration[5.2]
  def change
    remove_column :ctf_points, :teams, :boolean
    remove_column :ctf_points, :users, :boolean
  end
end

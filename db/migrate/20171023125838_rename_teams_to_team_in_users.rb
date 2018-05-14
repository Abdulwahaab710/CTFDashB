# frozen_string_literal: true

class RenameTeamsToTeamInUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :teams_id, :team_id
  end
end

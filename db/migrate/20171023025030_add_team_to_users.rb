# frozen_string_literal: true

class AddTeamToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :teams, foreign_key: true
  end
end

class AddScoreToTeam < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :score, :integer, default: 0
  end
end

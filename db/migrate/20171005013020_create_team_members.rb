class CreateTeamMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :team_members do |t|
      t.references :teams, foreign_key: true
      t.references :users, foreign_key: true

      t.timestamps
    end
  end
end

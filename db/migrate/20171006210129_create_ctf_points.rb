# frozen_string_literal: true

class CreateCtfPoints < ActiveRecord::Migration[5.0]
  def change
    create_table :ctf_points do |t|
      t.references :users, foreign_key: true
      t.references :challenges, foreign_key: true
      t.references :teams, foreign_key: true
      t.float :points

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateHints < ActiveRecord::Migration[5.0]
  def change
    create_table :hints do |t|
      t.references :challenges, foreign_key: true
      t.float :penalty
      t.string :description
      t.string :link

      t.timestamps
    end
  end
end

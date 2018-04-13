class CreateChallenges < ActiveRecord::Migration[5.0]
  def change
    create_table :challenges do |t|
      t.float :points
      t.integer :max_tries
      t.string :link
      t.text :description

      t.timestamps
    end
  end
end

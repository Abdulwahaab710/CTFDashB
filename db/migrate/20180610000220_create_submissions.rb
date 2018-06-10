class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.string :flag
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true
      t.string :submission_hash

      t.timestamps
    end
  end
end

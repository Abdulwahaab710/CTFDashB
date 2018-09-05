class CreateHints < ActiveRecord::Migration[5.2]
  def change
    create_table :hints do |t|
      t.references :challenge, foreign_key: true
      t.text :hint_text
      t.float :penalty, default: 0

      t.timestamps
    end
  end
end

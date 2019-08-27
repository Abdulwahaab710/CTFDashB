class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :path
      t.text :html_content

      t.timestamps
    end
    add_index :pages, :path, unique: true
  end
end

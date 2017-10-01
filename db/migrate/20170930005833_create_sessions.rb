class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.references :user, foreign_key: true
      t.string :ip_address
      t.string :browser

      t.timestamps
    end
  end
end

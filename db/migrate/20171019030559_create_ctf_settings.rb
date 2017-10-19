class CreateCtfSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :ctf_settings do |t|
      t.integer :max_teammates

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateCtfSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :ctf_settings do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end

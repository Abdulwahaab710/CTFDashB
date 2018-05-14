# frozen_string_literal: true

class CreateCtfAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :ctf_admins do |t|
      t.references :users, foreign_key: true
      t.references :capture_the_flag, foreign_key: true

      t.timestamps
    end
  end
end

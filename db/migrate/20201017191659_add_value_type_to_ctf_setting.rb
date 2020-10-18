class AddValueTypeToCtfSetting < ActiveRecord::Migration[5.2]
  def change
    add_column :ctf_settings, :value_type, :string
  end
end

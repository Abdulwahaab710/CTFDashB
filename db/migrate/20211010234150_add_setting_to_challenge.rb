class AddSettingToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :setting, :text
  end
end

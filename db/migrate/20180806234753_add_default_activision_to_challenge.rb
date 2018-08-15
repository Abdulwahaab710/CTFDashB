class AddDefaultActivisionToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :default_activision, :boolean
  end
end

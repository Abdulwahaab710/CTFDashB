class AddActiveFlagAndCategoryToChallenge < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :active, :boolean
    add_column :challenges, :flag, :string
    add_reference :challenges, :category, foreign_key: true
  end
end

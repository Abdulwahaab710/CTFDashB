class AddTitleToChallenge < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :title, :string
  end
end

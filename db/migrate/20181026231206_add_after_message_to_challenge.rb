class AddAfterMessageToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :after_message, :string
  end
end

class AddUserToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_reference :challenges, :user, foreign_key: true
  end
end

class AddChallengeCategoriesToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_reference :challenges, :challenge_category, foreign_key: true
  end
end

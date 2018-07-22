class AddValidSubmissionAndCategoryAndChallengeToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :valid_submission, :boolean
    add_reference :submissions, :category, foreign_key: true
    add_reference :submissions, :challenge, foreign_key: true
  end
end

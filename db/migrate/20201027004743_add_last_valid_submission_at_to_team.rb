class AddLastValidSubmissionAtToTeam < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :last_valid_submission_at, :timestamp
  end
end

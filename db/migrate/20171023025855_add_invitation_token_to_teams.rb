# frozen_string_literal: true

class AddInvitationTokenToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :invitation_token, :string
  end
end

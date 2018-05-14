# frozen_string_literal: true

class AddAdminAndOrganizerToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :organizer, :boolean
  end
end

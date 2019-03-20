# frozen_string_literal: true

module Admin
  class UserManagementsController < AdminController
    before_action :admin_user?

    def index
      @users = User.all
    end

    def add_admin
      user = User.find_by(username: params[:id])
      user.update(admin: true, organizer: true)
      flash_and_redirect_to_index("#{user.name} is now an admin.")
    end

    def add_organizer
      user = User.find_by!(username: params[:id])
      user.update(organizer: true)
      flash_and_redirect_to_index("#{user.name} is now an organizer.")
    end

    def remove_admin
      user = User.find_by(username: params[:id])
      user.update(admin: false)
      flash_and_redirect_to_index("Admin privileges has been successfully removed from #{user.name}")
    end

    def remove_organizer
      user = User.find_by(username: params[:id])
      user.update(organizer: false)
      flash_and_redirect_to_index("Organizer privileges has been successfully removed from #{user.name}")
    end

    def deactivate
      user = User.find_by!(username: params[:id])
      user.update(active: false)
      flash_and_redirect_to_index("#{user.name} has been successfully deactivated.")
    end

    def activate
      user = User.find_by!(username: params[:id])
      user.update(active: true)
      flash_and_redirect_to_index("#{user.name} has been successfully activated.")
    end

    private

    def admin_user?
      return head 404 unless current_user&.admin?
    end

    def flash_and_redirect_to_index(flash_message)
      flash[:success] = flash_message
      redirect_to action: :index
    end
  end
end

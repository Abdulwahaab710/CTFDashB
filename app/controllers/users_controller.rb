# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[new create show]
  before_action :admin_user?, only: %i[index add_organizer add_admin remove_organizer remove_admin activate deactivate]
  layout 'settings_layout', only: %i[profile_settings security_settings change_password]
  include Sessions

  def create
    @user = User.new(user_params)
    render :new, status: :bad_request unless @user.save
    flash[:success] = 'Welcome to the CTFDashB, your account has been create'
    redirect_to join_team_path unless performed?
  rescue ActionController::ParameterMissing
    flash[:error] = 'Required parameters are missing.'
    render :new, status: :bad_request
  end

  def new
    redirect_back_or current_user if logged_in?
    @user = User.new
    render :new
  end

  def show
    @user = User.find_by!(username: params[:id])
    redirect_to join_team_path if @user&.team&.nil? && logged_in_user?(@user) && !@user.organizer?
  rescue ActiveRecord::RecordNotFound
    render file: Rails.root.join('public', '404.html'), status: :not_found
  end

  def update
    @user = current_user
    redirect_to @user if @user.update(user_params_without_password)
    render :profile_settings unless performed?
  end

  def security_settings
    @user = current_user
  end

  def profile_settings
    @user = current_user
  end

  def change_password
    @user = current_user
    if current_user.authenticate(params[:current_password])
      if current_user.update(password_params)
        destroy_all_session_except_current_session session[:user_session_id]
        flash[:success] = 'Password has been successfully updated'
        render :security_settings
      else
        flash[:danger] = "Password confirmation doesn't match Password"
        return render :security_settings, status: :unprocessable_entity
      end
    else
      flash[:danger] = 'Invalid password'
      render :security_settings, status: :unprocessable_entity
    end
  end

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

  def flash_and_redirect_to_index(flash_message)
    flash[:success] = flash_message
    redirect_to action: :index
  end

  def destroy_all_session_except_current_session(session_id)
    current_user.sessions.where.not(id: session_id).destroy_all
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end

  def user_params_without_password
    params.require(:user).permit(:name, :username, :email)
  end

  def password_params
    params.permit(
      :password,
      :password_confirmation
    )
  end

  def admin_user?
    return head 404 unless current_user&.admin?
  end
end

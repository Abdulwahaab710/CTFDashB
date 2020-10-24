# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[new create show]
  layout 'settings_layout', only: %i[profile_settings security_settings change_password]

  include Sessions

  def create
    @user = User.new(user_params)
    return render :new, status: :bad_request unless @user.save

    flash[:success] = 'Welcome to the CTFDashB, your account has been create'
    log_in @user
    redirect_to join_team_path
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
      update_password
    else
      flash.now[:danger] = 'Invalid password'
      render :security_settings, status: :unprocessable_entity
    end
  end

  private

  def update_password
    return render :security_settings, status: :unprocessable_entity unless current_user.update(password_params)

    destroy_all_session_except_current_session session[:user_session_id]
    flash.now[:success] = 'Password has been successfully updated'
    render :security_settings
  end

  def destroy_all_session_except_current_session(session_id)
    current_user&.sessions&.where&.not(id: session_id)&.destroy_all
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
end

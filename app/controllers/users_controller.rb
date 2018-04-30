# User controller
class UsersController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[new create]
  include Sessions
  include CtfSettings

  def new
    if logged_in?
      redirect_back_or current_user
    else
      @user = User.new
      render :new
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    redirect_to join_team_path if @user&.team && logged_in_user?(@user) && !@user.organizer?
  end

  def edit
    @user = current_user
    if @user.update_attributes(user_params_without_password)
      redirect_to @user
    else
      render :settings
    end
  end

  def settings
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the #{ctf_name}, your account has been create"
      redirect_to join_team_path
    else
      render :new unless @user.save
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end

  def user_params_without_password
    params.require(:user).permit(:name, :username, :email)
  end
end

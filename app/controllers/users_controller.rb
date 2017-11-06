# User controller
class UsersController < ApplicationController
  before_action :user_logged_in?, only: [:edit]
  include SessionsHelper

  def new
    redirect_back_or current_user if logged_in?
    @user = User.new
    render :new
  end

  def show
    @user = User.find_by(id: params[:id])
    redirect_to join_team_path if @user.team.nil?
  end

  def edit; end

  def create
    @user = User.new(user_params)
    render :new unless @user.save!
    flash[:success] = 'Welcome to the CTFDashB, your account has been create'
    redirect_to join_team_path
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end
end

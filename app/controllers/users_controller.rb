# User controller
class UsersController < ApplicationController
  before_action :user_logged_in?, only: [:edit]
  include SessionsHelper

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
    redirect_to join_team_path if @user.team.nil?
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Welcome to the CTFDashB, your account has been create'
      redirect_to join_team_path
    else
      render :new
    end
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

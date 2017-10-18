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
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Welcome to the CTFDashB'
      redirect_to @user
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

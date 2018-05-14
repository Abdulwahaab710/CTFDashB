# frozen_string_literal: true

# User controller
class UsersController < ApplicationController
  # before_action :user_logged_in?, except: %i[new create show]
  before_action :user_logged_in?, except: %i[new create]
  include Sessions

  def create
    @user = User.new(user_params)
    render :new unless @user.save
    flash[:success] = 'Welcome to the CTFDashB, your account has been create'
    redirect_to join_team_path unless performed?
  end

  def new
    redirect_back_or current_user if logged_in?
    @user = User.new
    render :new
  end

  def show
    @user = User.find_by!(username: params[:id])
    redirect_to join_team_path if @user&.team&.nil? && logged_in_user?(@user) && !@user.organizer?
  end

  def edit
    @user = current_user
    redirect_to @user if @user.update(user_params_without_password)
    render :settings unless performed?
  end

  def settings
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end

  def user_params_without_password
    params.require(:user).permit(:name, :username, :email)
  end
end

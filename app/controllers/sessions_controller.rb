# Session controller
class SessionsController < ApplicationController
  include SessionsHelper

  def new
    if logged_in?
      redirect_back_or current_user
    else
      render :new
    end
  end

  def create
    # TODO ALLOW USERS TO LOGIN VIA USERNAME OR EMAIL
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or user
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    current_session = Session.find_by(id: session[:user_session_id])
    current_session.destroy
    session[:session_id] = nil
  end
end
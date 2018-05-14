# frozen_string_literal: true

# Session controller
class SessionsController < ApplicationController
  include Sessions

  def new
    redirect_back_or current_user if logged_in?
    render :new unless performed?
  end

  def create
    # TODO: ALLOW USERS TO LOGIN VIA USERNAME OR EMAIL
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_back_or user
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    @current_session = Session.find_by(id: session[:user_session_id])
    @current_session.destroy
    session[:session_id] = nil
    redirect_to root_path
  end
end

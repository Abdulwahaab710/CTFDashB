# frozen_string_literal: true

# Session controller
class SessionsController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[new create]
  layout 'settings_layout', only: %i[users_sessions destroy_session]
  include Sessions

  def new
    redirect_back_or current_user if logged_in?
    render :new unless performed?
  end

  def create
    user = find_user
    if user&.authenticate(params[:session][:password])
      return account_is_disabled unless user.active?
      log_in user
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unauthorized
    end
  end

  def destroy
    @current_session = Session.find_by(id: session[:user_session_id])
    @current_session.destroy
    session[:session_id] = nil
    redirect_to root_path
  end

  def users_sessions
    @current_session = session[:user_session_id]
    @sessions = current_user.sessions.map do |s|
      {
        user_agent: BrowserSniffer.new(s.browser),
        ip_address: s.ip_address,
        id: s.id
      }
    end
  end

  def destroy_session
    @session = current_user.sessions.find_by(id: params[:id])
    return head 404 if @session.nil?
    @session.destroy
  end

  private

  def account_is_disabled
    flash[:danger] = 'Your account is disabled'
    render 'new', status: :unauthorized
  end

  def find_user
    if email?(params[:session][:email])
      User.find_by(email: params[:session][:email].downcase)
    else
      User.find_by(username: params[:session][:email])
    end
  end

  def email?(email)
    email =~ /[A-Za-z0-9\.]+@[A-Za-z0-9\.]+/
  end
end

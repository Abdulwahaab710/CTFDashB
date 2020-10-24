# frozen_string_literal: true

module Sessions
  extend ActiveSupport::Concern

  included do
    before_action :user_logged_in?
  end

  def log_in(user)
    current_session = Session.new(
      user: user,
      ip_address: request.remote_ip,
      browser: request.user_agent
    )
    current_session.save
    session[:user_session_id] = current_session.id
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def logged_in_user?(user)
    !current_user.nil? && user.id == current_user.id
  end

  def current_user
    @current_user ||= Session.find_by(id: session[:user_session_id])
    return @current_user.user if !@current_user.nil? && @current_user.class == Session
  end

  def logged_in?
    !current_user.nil?
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get? && request.original_fullpath != '/login'
  end

  def logout_all_sessions_for_a_user(user)
    user.sessions.delete_all
  end

  private

  def user_logged_in?
    return if logged_in?
    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def destroy_all_session_except_current_session(session_id)
    current_user.sessions.where.not(id: session_id).destroy_all
  end
end

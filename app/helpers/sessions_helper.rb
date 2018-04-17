# Session helper
module SessionsHelper
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

  def is_logged_in_user?(user)
    return !current_user.nil? && user.id == current_user.id
  end

  def current_user
    @current_user ||= Session.find_by(id: session[:user_session_id])
    return @current_user.user if !@current_user.nil? && @current_user.class == Session
  end

  def logged_in?
    !current_user.nil?
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?  && request.original_fullpath != '/login'
  end
end

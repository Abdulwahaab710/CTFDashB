class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :user_logged_in?

  include Sessions

  private

  def user_logged_in?
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end

# frozen_string_literal: true

class Oauth2CallbacksController < ApplicationController
  skip_before_action :user_logged_in?
  skip_before_action :ctf_has_started?
  skip_before_action :submission_closed?

  def google
    handle_auth
    log_in @user

    return redirect_to join_team_path if @user.team.nil?

    redirect_back_or @user
  end

  private

  def handle_auth
    @user = User.find_by(email: user_info['email'])

    create_user if @user.nil?
  end

  def create_user
    password = SecureRandom.hex

    @user = User.create!(
      name: user_info['name'],
      email: user_info['email'],
      username: user_info['name'].gsub(' ', '_'),
      password: password,
      password_confirmation: password
    )

    flash[:success] = 'Welcome to CTFDashB! Your account has been created.'
  end

  def user_info
    @user_info ||= request.env.dig('omniauth.auth', 'info')
  end
end

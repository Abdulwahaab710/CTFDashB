class ChallengesController < ApplicationController
  before_action :user_logged_in?, except: [:index]

  def new
  end

  def create
  end

  def index
  end

  def show
  end

  def destroy
  end

  def activate
  end

  def deactivate
  end
end

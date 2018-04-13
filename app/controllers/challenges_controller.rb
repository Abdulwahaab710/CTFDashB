class ChallengesController < ApplicationController
  before_action :user_logged_in?, except: [:index]

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = Challenge.create!(challenge_params)
  end

  def index
    @challenges = Challenge.all
  end

  def show
  end

  def destroy
  end

  def activate
  end

  def deactivate
  end

  private

  def challenge_params
    params.require(:challenge).permit(
      :title,
      :description,
      :link,
      :points,
      :max_tries
    )
  end
end

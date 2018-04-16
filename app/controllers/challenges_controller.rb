class ChallengesController < ApplicationController
  before_action :user_logged_in?, except: [:index]

  def index
    @challenges = Challenge.all
  end

  def new
    @challenge = Challenge.new
    @category = Category.order(:name)
  end

  def create
    @challenge = Challenge.new(challenge_params)
    redirect_to @challenge if @challenge.save
    render :new unless performed?
  end

  def show
    @challenge = Challenge.find_by(id: params[:id])
  end

  def destroy
    @challenge = Challenge.find_by(id: params[:id])
    @challenge.destroy
  end

  def activate
    @challenge = Challenge.find_by(id: params[:id])
    @challenge.activate
  end

  def deactivate
    @challenge = Challenge.find_by(id: params[:id]).deactivate
    @challenge.activate
  end

  private

  def challenge_params
    params.require(:challenge).permit(
      :title,
      :description,
      :link,
      :points,
      :max_tries,
      :active,
      :category_id
    )
  end
end

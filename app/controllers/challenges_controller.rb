class ChallengesController < ApplicationController
  before_action :user_logged_in?, except: %i[index]
  before_action :user_has_permission?, except: %i[index show]

  include Users

  def index
    @challenges = Challenge.where(active: true)
    @challenges = Challenge.all if current_user.organizer?
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

  def edit
    @challenge = Challenge.find_by(id: params[:id])
  end

  def update
    @challenge = Challenge.find_by(id: params[:id])
    render :edit unless @challenge.update_attributes(challenge_params)
    redirect_to @challenge unless performed?
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

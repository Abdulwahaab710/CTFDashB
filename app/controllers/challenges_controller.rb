# frozen_string_literal: true

class ChallengesController < ApplicationController
  before_action :user_logged_in?, except: %i[index]
  before_action :user_has_permission?, except: %i[index show]
  before_action :fetch_categories

  include Users

  def index
    @challenges = Challenge.where(active: true)
    @challenges = Challenge.all if current_user&.organizer?
  end

  def new
    @challenge = Challenge.new
    @category = Category.order(:name)
  end

  def create
    @challenge = Challenge.new(challenge_params)
    redirect_to [@challenge.category, @challenge] if @challenge.save
    render :new unless performed?
  end

  def edit
    @challenge = challenge
  end

  def update
    @challenge = challenge
    render :edit unless @challenge.update(challenge_params)
    redirect_to [@challenge.category, @challenge] unless performed?
  end

  def show
    @challenge_submission = Submission.new
    @challenge = challenge
  end

  def destroy
    challenge&.destroy
  end

  def activate
    @challenge = challenge
    @challenge.active = true
    redirect_to action: :index if @challenge.save!
  end

  def deactivate
    @challenge = challenge
    @challenge.active = false
    redirect_to action: :index if @challenge.save!
  end

  private

  def challenge
    Category.find_by!(id: params[:category_id]).challenges.find_by(id: params[:id])
  end

  def fetch_categories
    @categories = Category.all
  end

  def challenge_params
    params.require(:challenge).permit(
      :title,
      :description,
      :link,
      :points,
      :flag,
      :max_tries,
      :active,
      :category_id
    )
  end
end

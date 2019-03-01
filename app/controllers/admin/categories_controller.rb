# frozen_string_literal: true

module Admin
  class CategoriesController < ApplicationController
    before_action :fetch_categories

    include Users
    include CtfSettings

    def index
      @categories = Category.all
      @challenges = Challenge.active
      @team_submissions = team_submissions
      return render 'challenges/index' unless current_user&.organizer?
    end

    def show
      @category = Category.find_by!(id: params[:id])
      @team_submissions = team_submissions
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      return render :new unless @category.save

      redirect_to polymorphic_path([:admin, @category])
    end

    def edit
      @category = Category.find_by!(id: params[:id])
    end

    def update
      @category = Category.find_by!(id: params[:id])
      return render :edit unless @category.update(category_params)

      redirect_to @category
    end

    def destroy
      @category = Category.find_by!(id: params[:id])
      redirect_to :show unless @category.destroy
      flash[:success] = "You have successfully delete #{@category.name}"
      redirect_to categories_path unless performed?
    end

    private

    def fetch_categories
      @categories = Category.all
    end

    def category_params
      params.require(:category).permit(:name)
    end

    def team_submissions
      Submission.where(team: current_user&.team).group(:challenge_id).count
    end
  end
end

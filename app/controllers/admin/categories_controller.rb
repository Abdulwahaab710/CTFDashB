# frozen_string_literal: true

module Admin
  class CategoriesController < AdminController
    before_action :fetch_categories
    before_action :fetch_category, except: %i[index new create]

    include Users
    include CtfSettings

    def index
    end

    def show
      @team_submissions = team_submissions
      @challenges = Challenge.where(category_id: params[:id]).includes(:challenge_files_attachments, :category)
                             .page(params[:page] || 1)
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      return render :new unless @category.save

      redirect_to admin_category
    end

    def edit
    end

    def update
      return render :edit unless @category.update(category_params)

      redirect_to admin_category
    end

    def destroy
      return redirect_to :show unless @category.destroy

      flash[:success] = "You have successfully deleted #{@category.name}"
      redirect_to admin_categories_path
    end

    private

    def fetch_category
      @category = Category.find_by!(id: params[:id])
    end

    def fetch_categories
      @categories = Category.all
    end

    def category_params
      params.require(:category).permit(:name, :description)
    end

    def team_submissions
      Submission.where(team: current_user&.team).group(:challenge_id).count
    end

    def admin_category
      polymorphic_path([:admin, @category])
    end
  end
end

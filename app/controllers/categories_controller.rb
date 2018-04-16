class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name)
  end

  def show
    @category = Category.find_by(id: params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(challenge_params)
    render :new unless @category.save
  end

  def edit
    @category = Category.update_attr
  end

  def destroy
    @category = Category.find_by(id: params[:id])
    @category.destroy
  end

  private

  def challenge_params
    params.require(:category).permit(:name)
  end
end

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
    @category = Category.new(category_params)
    render :new unless @category.save
    redirect_to @category unless performed?
  end

  def edit
    @category = Category.find_by(id: params[:id])
  end

  def update
    @category = Category.find_by(id: params[:id])
    render :edit unless @category.update_attributes(category_params)
    redirect_to @category unless performed?
  end

  def destroy
    @category = Category.find_by(id: params[:id])
    redirect_to :show unless @category.destroy
    flash[:success] = "You have successfully delete #{@category.name}"
    redirect_to categories_path unless performed?
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end

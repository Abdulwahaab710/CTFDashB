# frozen_string_literal: true

module Admin
  class PagesController < AdminController
    def index
      @pages = Page.all
    end

    def new
      @page = Page.new
    end

    def create
      @page = Page.new(page_params)
      return redirect_to admin_pages_path if @page.save

      render :new, status: :unprocessable_entity
    end

    def edit
      @page = Page.find_by!(path: params[:path])
    end

    def update
      @page = Page.find_by!(path: params[:path])
      return redirect_to admin_pages_path if @page.update!(page_params)

      render :edit, status: :unprocessable_entity
    end

    def destroy
      page = Page.find_by!(path: params[:path])
      page.destroy
      flash[:success] = 'The page has been successfully deleted'
      redirect_to admin_pages_path
    end

    private

    def page_params
      params.require(:page).permit(:html_content, :content_type, :include_layout).merge(path: clean_page_path)
    end

    def clean_page_path
      return params[:page][:path] unless params[:page][:path][0] == '/'

      params[:page][:path][1..-1]
    end
  end
end

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
      @page = Page.new(path: clean_page_path, html_content: page_params[:html_content])
      return redirect_to admin_pages_path if @page.save

      render :new, status: :unprocessable_entity
    end

    def edit
      @page = Page.find_by!(path: params[:path])
    end

    def update
      @page = Page.find_by!(path: params[:path])
      return redirect_to admin_pages_path if @page.update!(
        path: clean_page_path, html_content: page_params[:html_content]
      )

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
      params.require(:page).permit(:path, :html_content)
    end

    def clean_page_path
      return page_params[:path] unless page_params[:path][0] == '/'

      page_params[:path][1..-1]
    end
  end
end

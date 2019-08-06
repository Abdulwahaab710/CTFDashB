# frozen_string_literal: true

class PagesController < ApplicationController
  def show
    page = Page.find_by(path: params[:path])
    return render html: page&.html_content&.html_safe if page

    head :not_found
  end
end

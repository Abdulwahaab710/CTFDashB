# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :ctf_has_started?
  skip_before_action :submission_closed?

  def show
    page = Page.find_by(path: params[:path])
    return render html: page&.html_content&.html_safe if page

    head :not_found
  end
end

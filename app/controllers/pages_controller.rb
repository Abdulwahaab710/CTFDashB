# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :ctf_has_started?
  skip_before_action :submission_closed?

  def show
    page = Page.find_by(path: params[:path])

    return head :not_found unless page
    return render html: page.html_content.html_safe unless page.include_layout? || page.content_type != 'html'

    if page.content_type == 'markdown'
      @page_content = page.html_content.to_md
    else
      @page_content = page.html_content
    end
  end
end

# frozen_string_literal: true

module Markdownable
  extend ActiveSupport::Concern

  protected

  def markdown
    @markdown ||= Redcarpet::Markdown.new(MarkdownRenderer, markdown_extensions)
  end

  def markdown_extensions
    {
      no_intra_emphasis: true,
      autolink: true,
      lax_spacing: true,
      fenced_code_blocks: true
    }
  end
end

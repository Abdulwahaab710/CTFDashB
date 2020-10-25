# frozen_string_literal: true

class Page < ApplicationRecord
  validates :path, uniqueness: true
  validates :path, :html_content, presence: true
  validates :content_type, presence: true, inclusion: { in: %w{html markdown} }

  class String < SimpleDelegator
    include Markdownable

    def to_md
      markdown.render(to_s) if self
    end
  end

  def html_content
    String.new(self[:html_content])
  end

  def include_layout?
    include_layout
  end

  def to_param
    path.to_s
  end
end

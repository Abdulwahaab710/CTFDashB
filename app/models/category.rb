# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :challenges, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  class String < SimpleDelegator
    def to_md
      markdown.render(to_s) if self
    end

    private

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

  def description
    String.new(self[:description])
  end
end

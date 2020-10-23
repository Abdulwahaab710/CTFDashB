# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :challenges, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  class String < SimpleDelegator
    include Markdownable

    def to_md
      markdown.render(to_s) if self
    end
  end

  def description
    String.new(self[:description])
  end
end

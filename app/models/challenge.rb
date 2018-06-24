# frozen_string_literal: true

class Challenge < ApplicationRecord
  belongs_to :category

  validates :title, :description, :points, :max_tries, :category, :flag, presence: true
  validates :points, :max_tries, numericality: { greater_than_or_equal_to: 1 }
  validates :flag, uniqueness: true

  class String < SimpleDelegator
    def to_md
      markdown.render(to_s) if self
    end

    private

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::Safe)
    end
  end

  def flag=(flag)
    self[:flag] = BCrypt::Password.create(flag)
  end

  def description
    String.new(self[:description])
  end
end

# frozen_string_literal: true

class Page < ApplicationRecord
  validates :path, uniqueness: true
  validates :path, :html_content, presence: true

  def to_param
    path.to_s
  end
end

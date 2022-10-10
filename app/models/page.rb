# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id           :bigint           not null, primary key
#  html_content :text
#  path         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_path  (path) UNIQUE
#
class Page < ApplicationRecord
  validates :path, uniqueness: true
  validates :path, :html_content, presence: true

  def to_param
    path.to_s
  end
end

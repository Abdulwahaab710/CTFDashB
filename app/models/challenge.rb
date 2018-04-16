class Challenge < ApplicationRecord
  belongs_to :category

  validates :title, :description, :points, :max_tries, :category, presence: true
  validates :points, :max_tries, numericality: { greater_than_or_equal_to: 1 }

  def activate
    self.active = true
  end

  def deactivate
    self.active = false
  end
end

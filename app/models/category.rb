class Category < ApplicationRecord
  has_many :challenges

  validates_uniqueness_of :name
end

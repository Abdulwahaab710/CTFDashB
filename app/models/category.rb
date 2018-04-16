class Category < ApplicationRecord
  has_many :challenge

  validates_uniqueness_of :name
end

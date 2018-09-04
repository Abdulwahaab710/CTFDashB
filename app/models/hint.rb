class Hint < ApplicationRecord
  belongs_to :challenge
  validates :challenge, :hint_text, :penalty, presence: true
end

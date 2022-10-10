# == Schema Information
#
# Table name: hints
#
#  id           :bigint           not null, primary key
#  hint_text    :text
#  penalty      :float            default(0.0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :bigint
#
# Indexes
#
#  index_hints_on_challenge_id  (challenge_id)
#
# Foreign Keys
#
#  fk_rails_...  (challenge_id => challenges.id)
#
class Hint < ApplicationRecord
  belongs_to :challenge
  validates :challenge, :hint_text, :penalty, presence: true
end

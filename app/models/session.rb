# frozen_string_literal: true

# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  browser    :string
#  ip_address :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Session < ApplicationRecord
  belongs_to :user
end

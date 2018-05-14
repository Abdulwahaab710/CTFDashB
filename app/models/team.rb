# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :users
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :invitation_token,
            uniqueness: { case_sensitive: false }

  include Tokenable
end

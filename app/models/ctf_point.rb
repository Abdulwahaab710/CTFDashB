# frozen_string_literal: true

class CtfPoint < ApplicationRecord
  belongs_to :users
  belongs_to :challenges
  belongs_to :teams
end

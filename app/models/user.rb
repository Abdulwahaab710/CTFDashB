# frozen_string_literal: true

# User models
class User < ApplicationRecord
  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 255 }
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :username,
            presence: true,
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false }
  validates :password,
            presence: true,
            length: { minimum: 6 },
            on: :create
  has_secure_password
  belongs_to :team, optional: true
  has_many :sessions

  def admin?
    admin
  end

  def organizer?
    organizer
  end

  def to_param
    username.to_s.parameterize
  end
end

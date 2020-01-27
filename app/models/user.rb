# frozen_string_literal: true

# User models
class User < ApplicationRecord
  before_create { |user| user.active = true if user.active.nil? }
  before_save { |user| user.email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
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
            on: :create
  validates :password,
            confirmation: true

  validates :password_confirmation,
            presence: true,
            length: { minimum: 6 },
            if: ->(u) { !u.password.nil? }

  has_secure_password

  belongs_to :team, optional: true
  has_many :sessions, dependent: :destroy
  has_many :challenges, dependent: :nullify
  has_many :submissions, dependent: :nullify

  def admin?
    admin == true
  end

  def organizer?
    organizer == true
  end

  def to_param
    # TODO: fix username.to_s.parameterize ---> so that it doesn't make the letters lowercase
    username.to_s
  end

  def valid_submissions
    submissions.includes(:challenge, :category).valid_submissions
  end
end

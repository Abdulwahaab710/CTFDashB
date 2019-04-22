# frozen_string_literal: true

class Challenge < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :submissions, dependent: :destroy
  has_many_attached :challenge_files

  validates :title, :points, :max_tries, :category, :flag, presence: true
  validates :points, :max_tries, numericality: { greater_than_or_equal_to: 1 }
  validates :flag, uniqueness: true
  validate :flag_format, on: :create

  before_create { |challenge| challenge.flag = BCrypt::Password.create(flag) }

  scope :active, -> { where(active: true) }

  class String < SimpleDelegator
    def to_md
      markdown.render(to_s) if self
    end

    private

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::Safe)
    end
  end

  def description
    String.new(self[:description])
  end

  def after_message
    String.new(self[:after_message])
  end

  private

  def flag_format
    flag_regex = CtfSetting.find_by(key: 'flag_regex')&.value
    return unless flag_regex

    errors.add(:flag, 'Invalid flag format.') unless self[:flag] =~ Regexp.new(flag_regex)
  end
end

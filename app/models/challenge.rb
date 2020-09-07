# frozen_string_literal: true

class Challenge < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :submissions, dependent: :destroy
  has_many_attached :challenge_files

  validates :title, :points, :category, :flag, presence: true
  validates :max_tries, presence: true, numericality: { greater_than_or_equal_to: 1 }, unless: :unlimited_retries?
  validates :points, numericality: { greater_than_or_equal_to: 1 }
  validates :flag, uniqueness: true
  validate :flag_format, on: :create

  before_create { |challenge| challenge.flag = FlagHasher.new(flag).call }

  scope :active, -> { where(active: true) }

  class String < SimpleDelegator
    include Markdownable

    def to_md
      markdown.render(to_s) if self
    end
  end

  def description
    String.new(self[:description])
  end

  def after_message
    String.new(self[:after_message])
  end

  def activate
    return update(active: true) unless self.active

    errors.add(:active, "Challenge has been already activated")
    raise ActiveRecord::RecordInvalid.new(self)
  end

  def deactivate
    return update(active: false) if self.active

    errors.add(:active, "Challenge has been already deactivated")
    raise ActiveRecord::RecordInvalid.new(self)
  end

  private

  def flag_format
    flag_regex = CtfSetting.find_by(key: 'flag_regex')&.value
    return unless flag_regex

    errors.add(:flag, 'Invalid flag format.') unless self[:flag] =~ Regexp.new(flag_regex)
  end

  def unlimited_retries?
    CtfSetting.unlimited_retries?
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: challenges
#
#  id            :integer          not null, primary key
#  active        :boolean
#  after_message :string
#  description   :text
#  flag          :string
#  link          :string
#  max_tries     :integer
#  points        :float
#  setting       :text
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :integer
#  user_id       :bigint
#
# Indexes
#
#  index_challenges_on_category_id  (category_id)
#  index_challenges_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
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

  typed_store :setting do |s|
    s.boolean :regex_flag, default: false, null: false
    s.boolean :case_insensitive, default: false, null: false
  end

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

  private

  def flag_format
    return if regex_flag?

    flag_regex = CtfSetting.find_by(key: 'flag_regex')&.value
    return unless flag_regex

    errors.add(:flag, 'Invalid flag format.') unless self[:flag] =~ Regexp.new(flag_regex)
  end

  def unlimited_retries?
    CtfSetting.unlimited_retries?
  end
end

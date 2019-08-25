# frozen_string_literal: true

class CategoryDrop < Liquid::Drop
  def initialize(category)
    @category = category
  end

  def name
    @category.name
  end

  def challenges
    @challenges ||= @category&.challenges&.map { |challenge| ChallengeDrop.new(challenge) }
  end
end

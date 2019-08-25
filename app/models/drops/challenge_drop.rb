# frozen_string_literal: true

class ChallengeDrop < Liquid::Drop
  # TODO: add challenge_files
  def initialize(challenge)
    @challenge = challenge
  end

  def title
    @challenge.title
  end

  def points
    @challenge.points
  end

  def max_tries
    @challenge.max_tries
  end

  def description
    @challenge.description.to_md
  end

  def raw_description
    @challenge.description
  end

  def category
    @category ||= CategoryDrop.new(@challenge&.category)
  end

  def challenge_files
    @challenge_files ||= @challenge&.challenge_files&.map { |f| ChallengeFileDrop.new(f) }
  end
end

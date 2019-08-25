# frozen_string_literal: true

class TeamDrop < Liquid::Drop
  def initialize(team)
    @team = team
  end

  def name
    @team.name
  end

  def invitation_token
    @team&.invitation_token
  end

  def score
    @team&.score
  end

  def users
    @users ||= @team&.users&.map { |user| UserDrop.new(user) }
  end
end

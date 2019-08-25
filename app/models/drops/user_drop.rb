# frozen_string_literal: true

class UserDrop < Liquid::Drop
  def initialize(user)
    @user = user
  end

  def name
    @user.name
  end

  def username
    @user.username
  end

  def team
    @team ||= TeamDrop.new(@user&.team)
  end
end

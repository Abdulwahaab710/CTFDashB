class TeamsController < ApplicationController

  before_action :user_logged_in?

  def new
    @team = Team.new
  end

  def join
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    render :new unless @team.save
    add_team_member
    redirect_to @team
  end

  def join_team
    @team = Team.find_by(invitation_token: params[:invitation_token])
    @ctf = CTFSetting.find_by(key: 'max_teammates')
    if (@team.users.count + 1) <= @ctf.value
      flash.now[:error] = "Team #{@team.name} is already full"
      render :join
    end
    redirect_to @team if add_team_member
    render :join
  end

  private

  def add_team_member
    team_member = TeamMember.new(
      user: @user,
      team: @team
    )
    team_member.save
  end

  def team_params
    params.require(:team).permit(
      :name
    )
  end
end

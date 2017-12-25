# Teams controller
class TeamsController < ApplicationController
  before_action :user_logged_in?

  def show
    @team = Team.find_by(id: params[:id])
  end

  def new
    redirect_to current_user.team unless current_user.team.nil?
    @team = Team.new
  end

  def join
    redirect_to current_user.team unless current_user.team.nil?
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.invitation_token = generate_invitation_token
    return render :new unless @team.save
    add_team_member
    redirect_to @team
  end

  def join_team
    @ctf = CTFSetting.find_by(key: 'max_teammates')
    @team = Team.find_by(invitation_token: params[:team][:invitation_token])
    render_join_team
    return unless team_full?
    return redirect_to @team if add_team_member
    flash.now[:error] = 'Invalid token'
    render :join
  end

  private

  def render_join_team
    return nil unless @team.nil? || @team.id.nil?
    @team = Team.new
    flash.now[:error] = 'Invalid token'
    render :join
  end

  def add_team_member
    return nil if @team.id.nil?
    current_user.team = @team
    current_user.save!
  end

  def team_params
    params.require(:team).permit(
      :name
    )
  end

  def generate_invitation_token
    str = xor(current_user.username, @team.name)
    BCrypt::Password.create(str)
  end

  def xor(s1, s2)
    b1 = s1.unpack('U*')
    b2 = s2.unpack('U*')
    longest = [b1.length, b2.length].max
    b1 = [0] * (longest - b1.length) + b1
    b2 = [0] * (longest - b2.length) + b2
    b1.zip(b2).map { |a, b| a ^ b }.pack('U*')
  end

  def team_full?
    return true if (@team.users.count + 1) <= @ctf.value.to_i
    flash.now[:error] = "Team #{@team.name} is already full"
    render :join
  end
end

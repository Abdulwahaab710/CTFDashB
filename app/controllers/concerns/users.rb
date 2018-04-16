module Users
  extend ActiveSupport::Concern

  def user_has_permission?
    render file: "#{Rails.root}/public/404.html", status: 403, layout: false unless current_user.organizer?
  end
end

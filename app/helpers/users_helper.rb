# frozen_string_literal: true

# User helper
module UsersHelper
  def gravatar_for(user, size: 40, margin: nil, gravatar_size: 400)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    margin = margin.nil? == false ? "margin: #{margin}" : ''
    image_tag(
      build_gravatar_url(gravatar_id, gravatar_size),
      image_tag_params(user, size, margin)
    )
  end

  def user_status_button(user)
    return activate_user_link(user) unless user.active

    deactivate_user_link(user)
  end

  def user_admin_button(user)
    return add_admin_link(user) unless user.admin?

    remove_admin_link(user)
  end

  def user_orgainzer_button(user)
    return add_organizer_link(user) unless user.organizer?

    remove_organizer_link(user)
  end

  private

  def activate_user_link(user)
    link_to('Activate', activate_user_admin_user_path(user), method: :patch, class: 'btn btn-success')
  end

  def deactivate_user_link(user)
    link_to('Deactivate', deactivate_user_admin_user_path(user), method: :delete, class: 'btn btn-danger')
  end

  def add_admin_link(user)
    link_to(
      'Add admin privileges', add_admin_admin_user_path(user),
      method: :patch, class: 'btn btn-danger',
      data: { confirm: "Are you sure you want to give #{user.name} admin privileges" }
    )
  end

  def remove_admin_link(user)
    link_to(
      'Remove admin privileges', remove_admin_admin_user_path(user),
      method: :delete, class: 'btn btn-danger',
      data: { confirm: "Are you sure you want to remove #{user.name} admin privileges" }
    )
  end

  def add_organizer_link(user)
    link_to(
      'Add organizer privileges', add_organizer_admin_user_path(user),
      method: :patch, class: 'btn btn-danger',
      data: { confirm: "Are you sure you want to give #{user.name} organizer privileges" }
    )
  end

  def remove_organizer_link(user)
    link_to(
      'Remove organizer privileges', remove_organizer_admin_user_path(user),
      method: :delete, class: 'btn btn-danger',
      data: { confirm: "Are you sure you want to remove #{user.name} organizer privileges" }
    )
  end

  def build_gravatar_url(gravatar_id, gravatar_size)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{gravatar_size}"
  end

  def image_tag_params(user, size, margin)
    {
      alt: user.name,
      class: 'gravatar',
      width: size,
      height: size,
      style: "border-radius: 4px; #{margin}"
    }
  end
end

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

  private

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

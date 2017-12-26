# User helper
module UsersHelper
  def gravatar_for(user, size: 80, margin: nil)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    margin = margin.nil? == false ? "margin: #{margin}" : ''
    image_tag(
      gravatar_url,
      alt: user.name,
      class: 'gravatar',
      width: size,
      height: size,
      style: "border-radius: 4px; #{margin}"
    )
  end
end

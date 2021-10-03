module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :username, String, null: false
    field :team, TeamType, null: true
    field :admin, Boolean, null: true
    field :organizer, Boolean, null: true
    field :active, Boolean, null: true
    field :gravatar_url, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def gravatar_url
      gravatar_id = Digest::MD5.hexdigest(object.email.downcase)
      build_gravatar_url(gravatar_id)
    end

    def build_gravatar_url(gravatar_id)
      "https://secure.gravatar.com/avatar/#{gravatar_id}?&d=mm"
    end
  end
end

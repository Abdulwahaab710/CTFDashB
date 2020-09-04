module Types
  class SessionType < Types::BaseObject
    field :id, ID, null: false
    field :user, UserType, null: false
    field :ip_address, String, null: false
    field :browser, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

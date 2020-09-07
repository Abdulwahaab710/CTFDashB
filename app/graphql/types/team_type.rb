module Types
  class TeamType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :invitation_token, String, null: false
    field :score, Integer, null: true
    field :users, UserType.connection_type, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

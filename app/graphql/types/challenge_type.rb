module Types
  class ChallengeType < Types::BaseObject
    field :id, ID, null: false
    field :points, Float, null: false
    field :max_tries, Integer, null: false
    field :link, String, null: true
    field :description, String, null: false
    field :title, String, null: false
    field :active, Boolean, null: true
    field :flag, String, null: true
    field :category, Category, null: false
    field :user, UserType, null: false
    field :after_message, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

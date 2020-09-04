module Types
  class PageType < Types::BaseObject
    field :id, ID, null: false
    field :path, String, null: false
    field :html_content, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

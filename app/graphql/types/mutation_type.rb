module Types
  class MutationType < Types::BaseObject
    field :update_challenge, mutation: Mutations::UpdateChallenge
  end
end

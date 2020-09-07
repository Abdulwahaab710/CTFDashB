module Mutations
  class CreateChallenge < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false
    argument :points, Float, required: false
    argument :max_tries, Integer, required: true
    argument :link, String, required: true
    argument :active, Boolean, required: true
    argument :flag, String, required: true
    argument :category, CategoryType, required: true
    argument :after_message, String, required: false


    type Types::ChallengeType

    def resolve(**challenge_attributes)
      Challenge.create!(challenge_attributes.merge(user: current_user))
    end
  end
end

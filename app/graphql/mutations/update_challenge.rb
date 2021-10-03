module Mutations
  class UpdateChallenge < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :points, Float, required: false
    argument :max_tries, Integer, required: false
    argument :link, String, required: false
    argument :active, Boolean, required: false
    argument :flag, String, required: false
    argument :category_id, ID, required: false
    argument :after_message, String, required: false


    type Types::ChallengeType

    def resolve(id:, **challenge_attributes)
      challenge = Challenge.find(id)
      challenge.update!(challenge_attributes.compact)

      challenge
    end
  end
end

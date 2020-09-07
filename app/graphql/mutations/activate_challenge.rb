module Mutations
  class ActivateChallenge < BaseMutation
    argument :challenge, ChallengeType, required: true

    type Boolean

    def resolve(challenge:)
      challenge.activate
    end
  end
end

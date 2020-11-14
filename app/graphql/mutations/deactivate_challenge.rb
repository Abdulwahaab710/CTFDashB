module Mutations
  class DeactivateChallenge < BaseMutation
    argument :challenge, ChallengeType, required: true

    type Boolean

    def resolve(challenge:)
      challenge.deactivate
    end
  end
end

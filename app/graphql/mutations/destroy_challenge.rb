module Mutations
  class DestroyChallenge < BaseMutation
    argument :challenge, ChallengeType, required: true

    type Boolean

    def resolve(challenge:)
      challenge.destroy
    end
  end
end

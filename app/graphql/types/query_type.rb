module Types
  class QueryType < Types::BaseObject
    field :category, CategoryType, null: false
    field :categories, CategoryType.connection_type, null: false

    field :challenge, ChallengeType, null: false
    field :challenges, ChallengeType.connection_type, null: false

    field :user, UserType, null: false
    field :users, UserType.connection_type, null: false

    field :team, TeamType, null: false
    field :teams, TeamType.connection_type, null: false

    def category(id:)
      Category.find(id)
    end

    def categories
      Category.all
    end

    def challenge(id:)
      Challenge.find(id)
    end

    def challenges
      Challenge.all
    end

    def user(id:)
      User.find(id)
    end

    def users
      User.all
    end

    def team(id:)
      Team.find(id)
    end

    def teams
      Team.all
    end
  end
end

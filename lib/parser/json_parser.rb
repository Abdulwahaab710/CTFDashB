# frozen_string_literal: true

module Parser
  class JsonParser
    def initialize(challenges)
      @challenges = challenges
      create_challenges
    end

    private

    attr_reader :challenges

    def create_challenges
      challenges.each do |challenge|
        create_challenge(
          title: challenge['title'], category: find_or_create_category(challenge['category']),
          description: challenge['description'], points: challenge['points'].to_i,
          max_tries: challenge['max_tries'], link: challenge['link'],
          flag: challenge['flag'], active: false
        )
      end
    end

    def add_files_challenge(files)
      return if files.empty?
    end

    def find_or_create_category(name)
      Category.find_or_create_by(name: name)
    end

    def create_challenge(*challenge_params)
      Challenge.create(challenge_params)
    end
  end
end

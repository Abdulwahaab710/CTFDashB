class ChallengesImporterJob < ApplicationJob
  queue_as :challenge_importer

  def perform(challenges)
    challenges.each do |challenge|
      category = Category.find_or_create_by(
        name: challenge[:category][:name]
        description: challenge[:category][:description]
      )
      user = User.find_or_create_by(
        name: challenge[:user][:name],
        name: challenge[:user][:username],
        name: challenge[:user][:email],
      )
      Challenge.create(
        category: category,
        user: user,
        points: challenge[:points],
        max_tries: challenge[:max_tries],
        link: challenge[:link],
        description: challenge[:description],
        created_at: challenge[:created_at],
        updated_at: challenge[:updated_at],
        title: challenge[:title],
        active: challenge[:active],
        flag: challenge[:flag],
        after_message: challenge[:after_message],
      )
    end
  end
end

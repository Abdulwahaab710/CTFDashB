class ChallengesExporterJob < ApplicationJob
  queue_as :challenge_exporter

  def perform
    Challenge.all.as_json(
      include: {
        user: { only: [:name, :username, :email] },
        category: { only: [:name, :description] }
      },
      except: [:user_id, :category_id]
    )
  end
end

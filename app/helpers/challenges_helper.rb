# frozen_string_literal: true

module ChallengesHelper
  def challenge_status_button_tag(challenge)
    return activate_challenge_button(challenge) unless challenge.active?
    deactivate_challenge_button(challenge)
  end

  private

  def deactivate_challenge_button(challenge)
    challenge_status_button(
      'Deactivate challenge',
      'btn-danger',
      deactivate_category_challenge_path(challenge.category, challenge)
    )
  end

  def activate_challenge_button(challenge)
    challenge_status_button(
      'Activate challenge',
      'btn-success',
      activate_category_challenge_path(challenge.category, challenge)
    )
  end

  def challenge_status_button(btn_name, btn_color, path)
    link_to btn_name,
            path,
            class: "btn #{btn_color}",
            method: :patch
  end
end

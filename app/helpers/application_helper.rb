# frozen_string_literal: true

module ApplicationHelper
  def current_class?(path)
    return 'active' if request.path == path
    ''
  end
end

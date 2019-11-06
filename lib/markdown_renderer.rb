# frozen_string_literal: true

require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class MarkdownRenderer < Redcarpet::Render::Safe
  include Rouge::Plugins::Redcarpet
end

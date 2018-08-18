# frozen_string_literal: true

module Scraper
  class InvalidFormat < StandardError
    def initialize
      msg = 'Invalid format type. JSON or YAML files are supported'
      super
    end
  end

  class FileNameIsMissing < StandardError
    def initialize
      msg = 'Filename is missing'
      super
    end
  end

  class FormatIsMissing < StandardError
    def initialize
      msg = 'Format is missing'
      super
    end
  end

  class RepoIsMissing < StandardError
    def initialize
      msg = 'Repo is missing'
      super
    end
  end
end

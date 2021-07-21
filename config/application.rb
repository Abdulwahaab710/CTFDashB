# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CTFDashB
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.force_ssl                = true if Rails.env.production?
    logger                          = ActiveSupport::Logger.new(STDOUT)
    logger.formatter                = config.log_formatter
    config.log_tags                 = %i[subdomain uuid]
    config.logger                   = ActiveSupport::TaggedLogging.new(logger)
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths += Dir["#{config.root}/lib/**/"]
  end
end

# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CTFDashB
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.force_ssl                = true if Rails.env.production?
    logger                          = ActiveSupport::Logger.new(STDOUT)
    logger.formatter                = config.log_formatter
    config.log_tags                 = %i[subdomain uuid]
    config.logger                   = ActiveSupport::TaggedLogging.new(logger)
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'models', 'drops')
  end
end

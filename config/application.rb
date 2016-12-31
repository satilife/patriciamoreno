require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Patriciamoreno
  class Application < Rails::Application
    config.time_zone = 'Eastern Time (US & Canada)'
    config.assets.initialize_on_precompile = false

    config.cache_store = :redis_store

    config.autoload_paths += %W(
      #{config.root}/lib
      #{config.root}/app/presenters
      #{config.root}/app/services
    )

    config.assets.precompile += %w(
      admin.js
      admin.css
    )

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Stub views directory for anonymous controller testing (doesn't work outside this file)
    config.paths['app/views'] << 'spec/support/views' if Rails.env.test?

    # Use factorygirl as the fixture generator
    config.generators do |g|
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end

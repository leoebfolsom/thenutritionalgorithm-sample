require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "sprockets/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Workspace
  class Application < Rails::Application

    #config.assets.initialize_on_precompile = false
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
    }




  #  HandlebarsAssets::Config.template_namespace
   # if "assets" == ENV["RAILS_GROUPS"] || ["development", "test"].include?(ENV["RAILS_ENV"])
   #   HandlebarsAssets::Config.options = { data: true }
    #end
    
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
  #  config.active_record.raise_in_transactional_callbacks = true
    config.active_record.schema_format = :sql #added this when I added the
    #json nutrition_constraints based on advice from:
    # http://stackoverflow.com/questions/23284164/rails-3-migration-error-when-using-json-as-a-column-type-in-an-activerecord-bac
   # config.active_job.queue_adapter = :xxx
    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true

###LOGGER###
    #unless Rails.env.test?
      #log_level = String(ENV['LOG_LEVEL'] || "debug").upcase
      #config.logger = Logger.new(STDOUT)
      #config.logger.level = Logger.const_get(log_level)
      #config.log_level = log_level
      #config.lograge.enabled = true # see lograge section below...
    #end
###LOGGER###

  end
end

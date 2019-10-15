require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BotMessenger
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    unless Rails.env.production?
      bot_files = Dir[Rails.root.join('app', 'bot', '**', '*.rb')]
      bot_reloader = ActiveSupport::FileUpdateChecker.new(bot_files) do
        bot_files.each{ |file| require_dependency file }
      end

      ActiveSupport::Reloader.to_prepare do
        bot_reloader.execute_if_updated
      end

      bot_files.each { |file| require_dependency file }
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

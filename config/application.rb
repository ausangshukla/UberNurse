require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"
require 'dotenv/load'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UberNurse
  class Application < Rails::Application

    config.log_tags  = [:request_id, lambda { |request| request.headers["uid"] } ]
    
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = false
    config.autoload_paths += %W( #{Rails.root.to_s}/app/services #{Rails.root.to_s}/app/notifiers )

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          :methods => [:get, :post, :options, :put, :patch, :delete]
      end
    end


    config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[Error] ",
      :sender_address => %{"Admin" <admin@connuct.co.uk>},
      :exception_recipients => %w{thimmaiah@gmail.com admin@connuct.co.uk}
    }

    config.active_job.queue_adapter = :delayed_job
    config.to_prepare do
      Devise::Mailer.layout "mailer"
    end


    puts "########"
    puts "config/application.rb has settings to remove timezone aware attributes"
    puts "########"
    #config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false


    config.colorize_logging = false
    config.logstash.formatter = :json_lines

    # Optional, the logger to log writing errors to. Defaults to logging to $stderr
    config.logstash.error_logger = Logger.new($stderr)

    # Optional, max number of items to buffer before flushing. Defaults to 50
    config.logstash.buffer_max_items = 50

    # Optional, max number of seconds to wait between flushes. Defaults to 5
    config.logstash.buffer_max_interval = 5

    # Optional, drop message when a connection error occurs. Defaults to false
    config.logstash.drop_messages_on_flush_error = false

    # Optional, drop messages when the buffer is full. Defaults to true
    config.logstash.drop_messages_on_full_b

    config.logstash.host = 'localhost'
    config.logstash.type = :multi_logger
    config.logstash.outputs = [
      {
        type: :file,
        path: "log/#{Rails.env}.log",
        formatter: ::Logger::Formatter
      },
      {
        type: :udp,
        port: 55514,
        host: ENV["ELK_HOST"]
      }
    ]



  end
end

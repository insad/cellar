Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?


  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX


  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "orchid_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # ##################################################
  # ### Production Platform Specific Configuration ###
  # ##################################################

  # ### thinkspace ### #

  # Rack CORS configuration
  config.middleware.insert_before 0, 'Rack::Cors' do
    allow do
      origins '*'
      resource '*.woff', headers: :any, methods: :get
      resource '*.eot',  headers: :any, methods: :get
      resource '*.svg',  headers: :any, methods: :get
      resource '*.ttf',  headers: :any, methods: :get
    end
  end

  # Paperclip Storage
  config.paperclip_defaults = {
     storage: :s3,
       s3_credentials: {
         bucket: Rails.application.secrets.aws['s3']['paperclip']['bucket_name'],
         access_key_id: Rails.application.secrets.aws['s3']['paperclip']['access_key'],
         secret_access_key: Rails.application.secrets.aws['s3']['paperclip']['secret_access_key']
       },
   s3_protocol: :https
  }

  # Postmark SMTP
  config.action_mailer.smtp_settings = {
    address:              'smtp.postmarkapp.com',
    port:                 587,
    enable_starttls_auto: true,
    user_name:            Rails.application.secrets.smtp['postmark']['username'],
    password:             Rails.application.secrets.smtp['postmark']['password'],
    domain:               Rails.application.secrets.smtp['postmark']['domain'],
    authentication:       :cram_md5
  }

  Slim::Engine.options[:pretty] = true

  config.cache_store = :dalli_store,
  (ENV["MEMCACHIER_SERVERS"] || "").split(","),
    {:username => ENV["MEMCACHIER_USERNAME"],
    :password => ENV["MEMCACHIER_PASSWORD"],
    :failover => true,
    :socket_timeout => 1.5,
    :socket_failure_delay => 0.2
    }


end

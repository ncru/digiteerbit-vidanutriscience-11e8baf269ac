Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # comment this out if other mailers are not working in development
  config.action_mailer.default_url_options = { :host => "vidanutriscience.herokuapp.com" }

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  PAPERCLIP_STORAGE_OPTIONS = {
    :storage => :s3,
    :default_url => "https://vidanutriscience.s3-ap-southeast-1.amazonaws.com/assets/default-slider.jpg",
    :bucket => "vidanutriscience",
    :url => ':s3_alias_url',
    :s3_host_alias => 'vidanutriscience.s3-ap-southeast-1.amazonaws.com',
    :s3_credentials => YAML.load(ERB.new(File.read("#{Rails.root}/config/s3.yml")).result),
    :s3_protocol => 'https'
  }
  
  # for Paypal API - gem activemerchant
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
      login: "zaidiaz_10_api1.yahoo.com",
      password: "VM4SHFHN9EGD9KCG",
      signature: "AFcWxV21C7fd0v3bYYYRCpSSRl31AXz18kfUv3xvYSlPOfcYGugybnmW"
    }
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end

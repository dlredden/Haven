# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# these options are only needed if you choose smtp delivery
config.action_mailer.smtp_settings = {
  :address        => 'smtp.1and1.com',
  :port           => 25,
  :authentication => :login,
  :domain         => 'wikidlabs.com',
  :user_name      => 'hello@wikidlabs.com',
  :password       => 'Wikidpass789!'
}

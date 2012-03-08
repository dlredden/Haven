# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION
ENV['RAILS_ENV'] = 'development'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # CONFIG.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "xmlsimple", :lib => "xml-simple"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "strongbox"
  config.gem "subdomain-fu", :version => '0.5.4'
  config.gem "newrelic_rpm"
#  config.gem "remit"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
      :key => '_haven_session',
      :secret      => '202d094dd09f5cbdcc6dfc09377a533af4cbd089ec2c7ecaeca919a16c693436415dc82b0d16ca92c9102a9b95a34acfd8fe03bea373764a3bea1e3a3ba0baaa'
    }
  
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Central Time (US & Canada)'
  #config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

# These are the sizes of the domain (i.e. 0 for localhost, 1 for something.com)  
# for each of your environments  
SubdomainFu.tld_sizes = { :development => 1,  
                          :test => 1,  
                          :production => 1 }

# These are the subdomains that will be equivalent to no subdomain
SubdomainFu.mirrors = ["www"]

# This is the "preferred mirror" if you would rather show this subdomain  
# in the URL than no subdomain at all.
SubdomainFu.preferred_mirror = "www"
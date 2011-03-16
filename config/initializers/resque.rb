require 'resque'
require 'redis'
Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

resque_config = YAML.load_file(rails_root + '/config/resque.yml')
ENV["REDISTOGO_URL"] ||= "redis://amardaxini:a525975ce8ad19dfb4cedda993d0b755@catfish.redistogo.com:9192"

uri = URI.parse(ENV["REDISTOGO_URL"])

Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#Resque.redis = resque_config[rails_env]

# Schedule config :


# # Status config :
# Resque::Status.expire_in = (24 * 60 * 60) # 24hrs in seconds

# Resque Mailer config :
#Resque::Mailer.excluded_environments = [:test, :cucumber]

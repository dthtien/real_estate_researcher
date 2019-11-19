schedule_file = "config/schedule.yml"
require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.class_eval do
  use Rack::Protection, :except => :http_origin
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ENV["SIDEKIQ_USERNAME"] == username && ENV["SIDEKIQ_KEY"] == password
end


if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

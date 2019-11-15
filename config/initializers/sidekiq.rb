schedule_file = "config/schedule.yml"
require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  p '*'*20
  p ENV['SIDEKIQ_USERNAME']
  p ENV['SIDEKIQ_KEY']
  p '*'*20
  user == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_KEY']
end

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

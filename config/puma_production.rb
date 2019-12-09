workers 1
threads 1, 6

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
app_dir = '/home/deploy/top_lands_api'
current_dir = "#{app_dir}/current"
shared_dir = "#{app_dir}/shared"

# Specifies the `environment` that Puma will run in.
rails_env = ENV['RAILS_ENV'] || 'production'
environment rails_env

#Set up socket location
bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# setup master PID and state location
pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{current_dir}/config/database.yml")[rails_env])
end

before_fork do
  require 'puma_worker_killer'

  PumaWorkerKiller.config do |config|
    config.ram           = 1024 * 2 # mb
    config.frequency     = 60 # seconds
    config.percent_usage = 0.98
    config.rolling_restart_frequency = 12 * 3600 # 12 hours in seconds
    config.reaper_status_logs = false
  end
  PumaWorkerKiller.start
end

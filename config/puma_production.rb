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
bind "unix://#{shared_dir}/sockets/puma.sock"

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# setup master PID and state location
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{current_dir}/config/database.yml")[rails_env])
end
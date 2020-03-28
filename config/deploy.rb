# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'toplands'
set :repo_url, 'git@github.com:dthtien/real_estate_researcher.git'

# append :linked_files, '.env'
# append :linked_dirs, 'node_modules'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
namespace :deploy do
  # desc 'Make sure local git is in sync with remote.'

  # task :check_revision do
    # on roles(:app) do
      # unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        # puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        # exit
      # end
    # end
  # end

  desc 'Build react app'
  task :build_docker_for_app do
    on roles(:web) do
      within current_path do
        execute "cd #{current_path} && docker stop $(docker ps -a -q  --filter ancestor=dthtien/toplands) || true"
        execute "mkdir #{current_path}/tmp/pids"
        execute "cd #{current_path} && docker build -t dthtien/toplands ."
        execute "shopt -s dotglob && cp #{shared_path}/config/* #{current_path}/config/"
        execute "cd #{current_path} && docker-compose run web bundle exec rails db:migrate"
        execute "cd #{current_path} && docker-compose up -d"
      end
    end
  end

#  before :starting, :check_revision
  after :finishing, :build_docker_for_app
end

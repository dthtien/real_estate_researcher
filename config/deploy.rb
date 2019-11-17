# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'top_lands_api'
set :repo_url, 'git@github.com:dthtien/real_estate_researcher.git'
set :user, 'deploy'
set :puma_threads, [0, 6]
set :puma_workers, 0
set :rails_env, :production

set :pty, true
set :use_sudo, false
set :deploy_via, :remote_cache
current_shared_path = "/home/#{fetch(:user, 'deploy')}/#{fetch(:application)}/shared"
set :puma_bind,       "unix://#{current_shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{current_shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{current_shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{current_shared_path}/log/puma.error.log"
set :puma_error_log,  "#{current_shared_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, keys: %w(~/.ssh/id_rsa) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :keep_releases, 5

# sidekiq configuation
set :sidekiq_options_per_process, ['--queue critical', '--queue default']
set :sidekiq_processes, 2
# set :sidekiq_log, File.join(shared_path, 'log', 'sidekiq.log')

set :linked_files, %w[config/database.yml config/master.key config/puma.rb]
set :rbenv_ruby, '2.6.0'
## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'correct lands data'
  task :correct_data do
    on roles(:app) do
      within current_path do
        with rails_env: :production do
          execute :bundle, :exec, 'rake correct_data:start'
        end
      end
    end
  end

  desc 'Update crontab with whenever'
  task :update_cron do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:smart_restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :cleanup
  after  :finishing,    :restart
  after  :finishing,    :update_cron
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma

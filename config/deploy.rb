# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'real_estate_researcher'
set :repo_url, 'git@github.com:dthtien/real_estate_researcher.git'
set :rails_env, 'production'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'
set :migration_role, :app
append :linked_files, 'config/database.yml'

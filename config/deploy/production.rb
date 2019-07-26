set :user, 'deploy'

server '3.86.68.36', user: fetch(:user), roles: %w[app db web]

set :deploy_to, "/home/#{fetch :user}/#{fetch :application}"

set :branch, :master

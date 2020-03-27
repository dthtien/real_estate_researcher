set :user, 'deploy'

server '172.16.205.130', user: fetch(:user), roles: %w[app db web]

set :deploy_to, "/home/#{fetch :user}/#{fetch :application}"

set :branch, :docker

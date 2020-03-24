set :user, 'deploy'

server '34.87.181.165', user: fetch(:user), roles: %w[app db web]
# server '40.112.62.102', user: fetch(:user), roles: %w[app db web]

set :deploy_to, "/home/#{fetch :user}/#{fetch :application}"

set :branch, :master

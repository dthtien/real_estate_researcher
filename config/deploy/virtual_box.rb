set :user, 'deploy'

server 'localhost', user: fetch(:user), roles: %w[app db web], port: '2200'

set :deploy_to, "/home/#{fetch :user}/#{fetch :application}"

set :branch, :master

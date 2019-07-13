role :app, 'deploy@localhost:2200'
role :web, 'deploy@localhost:2200'
set :user, 'deploy'

server 'localhost', user: fetch(:user), roles: %w[web app], port: '2200'

set :deploy_to, "/home/#{fetch :user}/#{fetch :application}"

set :branch, :develop

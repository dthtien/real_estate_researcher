require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ENV["SIDEKIQ_USERNAME"] == username && ENV["SIDEKIQ_KEY"] == password
  end

  mount Sidekiq::Web => '/sidekiq'

  namespace :v1, path: 'api/v1' do
    resources :addresses, only: %i[index show] do
      collection do
        get :address_names
      end
    end

    resources :lands, only: %i[index show] do
      resources :history_prices, only: %i[index]
    end
  end
end

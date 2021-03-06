require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'

  namespace :v1, path: 'api/v1' do
    resources :addresses, only: %i[index show] do
      collection do
        get :address_names
      end

      resources :price_loggers, only: %i[index]
    end

    resources :lands, only: %i[index show] do
      resources :history_prices, only: %i[index]
      resource :user
    end
  end
end

require 'sidekiq/web'
require 'sidekiq/cron/web'

class AdminConstraint
  def matches?(request)
    request.params[:key] == ENV['SIDEKIQ_KEY']
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

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

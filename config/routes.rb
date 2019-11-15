require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_KEY"]))
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

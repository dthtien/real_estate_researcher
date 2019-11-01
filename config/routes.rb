Rails.application.routes.draw do
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

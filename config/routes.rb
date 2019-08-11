Rails.application.routes.draw do
  namespace :v1, path: 'api/v1' do
    resources :addresses, shallow: true do
      collection do
        get :address_names
      end

      resources :lands
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

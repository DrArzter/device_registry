Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :devices, only: [] do
        post :assign, on: :collection
        post :unassign, on: :collection
      end

      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      post 'register', to: 'registrations#create'
    end
  end
end

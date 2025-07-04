Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :devices, only: [] do
        post :assign, on: :collection
        post :unassign, on: :collection
      end
    end
  end
end

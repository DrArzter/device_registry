Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :devices, only: [] do
        post :assgn
        post :unassign
      end
    end
  end
end

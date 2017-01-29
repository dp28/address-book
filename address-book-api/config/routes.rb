Rails.application.routes.draw do
  resources :people, only: [:create, :update]
end

Rails.application.routes.draw do
  resources :people, only: [:index, :create, :update, :destroy]
end

Rails.application.routes.draw do
  resources :people, only: [:create]
end

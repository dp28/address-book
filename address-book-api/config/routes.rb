Rails.application.routes.draw do
  resources :people, only: [:index, :create, :update, :destroy]

  resources :organisations, only: [:index, :create, :update, :destroy] do
    resources :people, only: [:index, :create], controller: 'organisation_people'
  end
end

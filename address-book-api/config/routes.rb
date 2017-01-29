Rails.application.routes.draw do
  resources :people, only: [:index, :create, :update, :destroy]

  resources :organisations, only: [:index, :create, :update, :destroy] do
    resources :people, only: [:index, :create, :destroy], controller: 'organisation_people'
  end
end

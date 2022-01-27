Rails.application.routes.draw do
  get 'users', to: 'users#index'
  get 'users/new'
  get 'users/create'
  resources :items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'sign_in', to: 'authentication#sign_in'
  post 'sign_up', to: 'authentication#sign_up'
  patch 'update', to: 'users#update'
end
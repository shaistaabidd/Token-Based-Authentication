Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"
  get 'users', to: 'users#index'
  get 'users/new'
  get 'users/create'
  resources :items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'otp_sign_in', to: 'authentication#otp_sign_in'
  post 'sign_in', to: 'authentication#sign_in'
  post 'sign_up', to: 'authentication#sign_up'
  patch 'update', to: 'profiles#update'
  post 'verify_otp', to: 'otps#verify_otp'
  post 'forgot_password', to: 'passwords#forgot_password'
  post 'reset_password', to: 'passwords#reset_password'
  # post 'create_gig', to: 'gigs#create_gig'
  # post 'update_gig', to: 'gigs#update_gig'
  # post 'destroy_gig', to: 'gigs#destroy_gig'
  resources :gigs
end
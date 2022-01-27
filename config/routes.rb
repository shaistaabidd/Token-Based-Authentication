Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"
  get 'users', to: 'users#index'
  get 'users/new'
  get 'users/create'
  resources :items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'sign_in', to: 'authentication#sign_in'
  post 'sign_up', to: 'authentication#sign_up'
  patch 'update', to: 'users#update'
  post '/send_otp_code', as: 'user_send_otp_code', to: 'users#send_code'
  post 'verify_otp', to: 'users#verify_otp'
end

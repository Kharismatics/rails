Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }   
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root to: 'homes#index'
  get '/messages', to: 'tasks#messages'
  resources :tasks
  get 'app', to: 'tasks#index'
end

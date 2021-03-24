Rails.application.routes.draw do
  # devise_for :users
  # # get 'welcome/index'
  # # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root to: 'welcome#index'

  # resources :tasks
  # get 'app', to: 'tasks#index'
  devise_for :users, controllers: { sessions: 'users/sessions' }   
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # resources :homes
  root to: 'homes#index'
  # root to: 'welcome#index'

  resources :tasks
  get 'app', to: 'tasks#index'
end

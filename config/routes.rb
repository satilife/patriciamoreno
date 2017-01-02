Rails.application.routes.draw do
  root 'welcome#index'

  # User Management
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations:      'users/registrations' }
  resources :identities, only: :destroy, param: :provider

  namespace :admin do
    get '/' => 'dashboard#index', as: :dashboard

    # Users
    resources :users do
      member { post 'reset_password' }
    end
  end
end

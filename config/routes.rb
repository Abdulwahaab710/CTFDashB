# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'challenges#index'

  get 'ctf_settings', to: 'ctf_settings#show', as: :ctf_settings
  post 'ctf_settings', to: 'ctf_settings#edit'
  delete 'ctf_settings', to: 'ctf_settings#edit'

  namespace :admin do
    resources :challenges, only: %i[new create index], as: :challenge

    resources :categories, except: %i[edit update destroy] do
      member do
        get 'edit'       => 'categories#edit', as: :edit
        patch 'edit'     => 'categories#update'
        delete ''        => 'categories#destroy', as: :delete
      end

      resources :challenges, except: %i[new create edit update destroy], as: :challenges do
        member do
          get 'edit'           => 'challenges#edit', as: :edit
          patch 'edit'         => 'challenges#update'
          patch 'update-flag'  => 'challenges#update_flag', as: :update_flag
          patch 'activate'     => 'challenges#activate', as: :activate
          patch 'deactivate'   => 'challenges#deactivate', as: :deactivate
          delete ''            => 'challenges#destroy', as: :delete
        end
      end
    end
  end

  scope :categories do
    resources :challenges, only: %i[new create index], as: :challenge
  end

  resource :categories, only: %i[index show] do
    resource :challenges, only: %i[index show]
  end

  resources :password_resets, only: %i[new create edit update]

  post '/category/:category_id/challenges/:id/submit', to: 'submissions#create', as: :submit_flag

  get '/challenges', to: 'challenges#index', as: :all_challenges

  get '/teams/new', to: 'teams#new', as: :new_team
  post '/teams/new', to: 'teams#create'

  get '/teams/join', to: 'teams#join', as: :join_team
  post '/teams/join', to: 'teams#join_team'

  delete '/teams/withdraw', to: 'teams#withdraw', as: :withdraw_from_team

  get '/teams/:id', to: 'teams#show', as: :team

  get '/signup', to: 'users#new', as: :signup
  post '/signup', to: 'users#create'

  get '/users', to: 'users#index', as: :users
  get '/users/:id', to: 'users#show', as: :user
  patch '/users/:id/activate', to: 'users#activate', as: :activate_user
  patch '/users/:id/admin', to: 'users#add_admin', as: :add_admin
  patch '/users/:id/organizer', to: 'users#add_organizer', as: :add_organizer
  delete '/users/:id', to: 'users#deactivate', as: :deactivate_user
  delete '/users/:id/admin', to: 'users#remove_admin', as: :remove_admin
  delete '/users/:id/organizer', to: 'users#remove_organizer', as: :remove_organizer

  get '/settings', to: 'users#profile_settings', as: :profile_settings
  patch '/settings', to: 'users#update'

  get '/settings/security', to: 'users#security_settings', as: :security_settings
  patch '/settings/security', to: 'users#change_password'

  get '/settings/sessions', to: 'sessions#users_sessions', as: :user_sessions
  delete '/settings/session/:id', to: 'sessions#destroy_session', as: :user_session

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/scores', to: 'scores#index', as: :score_board
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

# frozen_string_literal: true

Rails.application.routes.draw do
  USERNAME_REGEX = /[^\/]+/

  root to: 'challenges#index'

  post '/submit', to: 'general_submissions#create', as: :general_submission

  namespace :admin do
    root to: 'dashboard#index'
    get 'ctf_settings', to: 'ctf_settings#show', as: :ctf_settings
    post 'ctf_settings', to: 'ctf_settings#edit'
    delete 'ctf_settings', to: 'ctf_settings#edit'

    resources :challenges, only: %i[new create index], as: :challenge

    resources :categories, except: %i[edit update destroy] do
      member do
        get 'edit'       => 'categories#edit', as: :edit
        patch 'edit'     => 'categories#update'
        delete '/' => 'categories#destroy', as: :delete
      end

      resources :challenges, except: %i[new create edit update destroy], as: :challenges do
        member do
          get 'clone'          => 'challenges#clone', as: :clone
          get 'edit'           => 'challenges#edit', as: :edit
          patch 'edit'         => 'challenges#update'
          patch 'update-flag'  => 'challenges#update_flag', as: :update_flag
          patch 'activate'     => 'challenges#activate', as: :activate
          patch 'deactivate'   => 'challenges#deactivate', as: :deactivate
          delete '/' => 'challenges#destroy', as: :delete
          delete '/files/:file_id' => 'challenges#destroy_challenge_file', as: :delete_file
        end
      end
    end

    get '/users', to: 'user_managements#index', as: :users

    resources :users, constraints: { id: USERNAME_REGEX } do
      member do
        patch '/activate', to: 'user_managements#activate', as: :activate_user
        patch '/admin', to: 'user_managements#add_admin', as: :add_admin
        patch '/organizer', to: 'user_managements#add_organizer', as: :add_organizer
        delete '/', to: 'user_managements#deactivate', as: :deactivate_user
        delete '/admin', to: 'user_managements#remove_admin', as: :remove_admin
        delete '/organizer', to: 'user_managements#remove_organizer', as: :remove_organizer
      end
    end

    resource :pages, except: %i[show], as: :pages do
      member do
        get '/', to: 'pages#index'
        get '/new', to: 'pages#new', as: :new
        post '/new', to: 'pages#create'
        get '/:path/edit', to: 'pages#edit', as: :edit
        patch '/:path/edit', to: 'pages#update'
        delete '/:path', to: 'pages#destroy', as: :delete
      end
    end
  end

  get '/categories/:id', to: 'categories#show', as: :category

  get '/categories/:category_id/challenges/:id', to: 'challenges#show', as: :category_challenge

  scope :categories do
    resources :challenges, only: %i[new create index], as: :challenge
  end

  resource :categories, only: %i[show] do
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
  get '/users/:id', to: 'users#show', constraints: { id: USERNAME_REGEX }, as: :user

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
  get '/pages/:path', to: 'pages#show', as: :page
end

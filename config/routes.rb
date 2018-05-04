Rails.application.routes.draw do
  root to: 'challenges#index'

  get 'ctf_settings', to: 'ctf_settings#show', as: :ctf_settings
  post 'ctf_settings', to: 'ctf_settings#edit'
  delete 'ctf_settings', to: 'ctf_settings#edit'

  resources :categories, except: %i[edit update destroy] do |categories|
    member do
      get 'edit'       => 'categories#edit', as: :edit
      patch 'edit'     => 'categories#update'
      delete ''        => 'categories#destroy', as: :delete
    end

    resources :challenges, except: %i[new create edit update destroy], as: :challenges do
      member do
        get 'edit'           => 'challenges#edit', as: :edit
        patch 'edit'         => 'challenges#update'
        patch 'activate'     => 'challenges#activate', as: :activate
        patch 'deactivate'   => 'challenges#deactivate', as: :deactivate
        delete ''            => 'challenges#destroy', as: :delete
      end
    end
  end

  scope :categories do
    resources :challenges, only: %i[new create], as: :challenge
  end

  get '/challenges', to: 'challenges#index', as: :all_challenges

  get '/teams/new', to: 'teams#new', as: :new_team
  post '/teams/new', to: 'teams#create'

  get '/teams/join', to: 'teams#join', as: :join_team
  post '/teams/join', to: 'teams#join_team'

  get '/teams/:id', to: 'teams#show', as: :team

  get '/signup', to: 'users#new', as: :signup
  post '/signup', to: 'users#create'

  get '/users/:id', to: 'users#show', as: :user
  delete '/users/:id', to: 'users#deactivate', as: :deactivate_user

  get '/settings', to: 'users#settings', as: :settings
  patch '/settings', to: 'users#edit'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/scores', to: 'scores#index', as: :score_board
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

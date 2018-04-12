Rails.application.routes.draw do
  get 'ctf_settings/show', as: :ctf_settings

  get 'ctf_settings/new'

  get 'ctf_settings/create'

  get 'ctf_settings/edit'

  root to: 'challenges#index'

  get '/category/new', to: 'challenge_categories#new', as: :new_challenege_category
  post '/category/new', to: 'challenge_categories#create'

  get '/challenges/new', to: 'challenges#new', as: :new_challenege
  post '/challenges/new'

  get '/challenges/:id', to: 'challenges#show', as: :challenge
  delete '/challenges/:id', to: 'challenges#destroy', as: :delete_challenege

  put '/challenges/:id/activate', to: 'challenges#activate', as: :activate_challenge
  put '/challenges/:id/deactivate', to: 'challenges#deactivate', as: :deactivate_challenge

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

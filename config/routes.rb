Rails.application.routes.draw do
  get 'challenges/new'

  get 'challenges/create'

  get 'challenges/index'

  get 'challenges/show'

  get '/teams/new', to: 'teams#new', as: :new_team
  post '/teams/new', to: 'teams#create'

  get '/teams/join', to: 'teams#join', as: :join_team
  post '/teams/join', to: 'teams#join_team'

  get '/teams/:id', to: 'teams#show', as: :team

  get '/signup', to: 'users#new', as: :signup
  post '/signup', to: 'users#create'

  get '/users/:id', to: 'users#show', as: :user
  delete '/users/:id', to: 'users#deactivate', as: :deactivate_user

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/scores', to: 'scores#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

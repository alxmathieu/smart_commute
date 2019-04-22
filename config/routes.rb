Rails.application.routes.draw do
  resources :suggestions
  resources :itineraries # à retravailler pour n'avoir que les routes nécessaires
  devise_for :users
  root to: 'pages#home'
  mount ForestLiana::Engine => '/forest'
  get '/profile', to: 'pages#profile'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end

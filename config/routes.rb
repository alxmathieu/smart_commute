Rails.application.routes.draw do
  resources :suggestions
  match 'suggestions/:id/add_to_watchlist' => 'suggestions#add_to_watchlist', as: :suggestion_add_watchlist, via: [:get, :post]
  match 'suggestions/:id/remove_from_watchlist' => 'suggestions#remove_from_watchlist', as: :suggestion_remove_watchlist, via: [:get, :post]
  resources :itineraries # à retravailler pour n'avoir que les routes nécessaires
  resources :language_user_joints
  devise_for :users
  root to: 'pages#home'
  mount ForestLiana::Engine => '/forest'
  get '/profile', to: 'pages#profile'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end


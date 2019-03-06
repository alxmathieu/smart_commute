Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  resources :itineraries # à retravailler pour n'avoir que les routes nécessaires
  devise_for :users
  root to: 'pages#home'
  resources :suggestions

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end

Rails.application.routes.draw do
  
  root 'recipes#index'
  resources :recipes, only: [:index, :new, :create]
  resources :photos, only: [:create]

  post 'recipes/find'

  # get '*path' => 'recipes#index'

  post 'components/find'
  post 'components/get'

  post 'tags/find'

end

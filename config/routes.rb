Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/api/auth'
  
  root 'recipes#index'
  resources :recipes, only: [:index, :new, :create]
  resources :photos, only: [:create, :destroy]

  post 'recipes/find'

  # get '*path' => 'recipes#index'

  post 'components/find'
  post 'components/get'

  post 'tags/find'

end

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/api/auth'
  get "#{::OmniAuth::config.path_prefix}/:provider/callback", to: "devise_token_auth/omniauth_callbacks#redirect_callbacks"
  
  root 'recipes#index'
  resources :recipes, only: [:index, :create, :update, :destroy]
  resources :photos, only: [:create, :destroy]
  resources :tags, only: [:create]

  post 'recipes/find'
  post 'recipes/:id', to: 'recipes#show', defaults: { format: 'json' }
  post 'recipes/:id/edit', to: 'recipes#edit', defaults: { format: 'json' }

  post 'components/find'
  post 'components/get'

  post 'tags/find'
  post 'recipes/:recipe_id/tags', to: 'tags#for_recipe', defaults: { format: 'json' }

  get 'browse', to: 'browse#index'

  get '*path' => 'recipes#index'

end

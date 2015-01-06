Rails.application.routes.draw do
  
  root 'recipes#index'
  resources :recipes

  # get '*path' => 'recipes#index'

  post 'components/find'

end

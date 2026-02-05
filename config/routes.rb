Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :v1 do
    get 'user', to: 'users#my_profile'
    patch 'user/wallet', to: 'users#update_wallet'
    patch 'user/avatar', to: 'users#update_avatar'

    resources :categories, only: [:index]
    resources :items
    resources :favorites, only: [:create, :destroy]
  end
end

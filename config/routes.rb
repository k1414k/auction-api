Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :v1 do
    get 'user', to: 'users#my_profile'
    
    resource :wallet, only: [:show] do
      patch :balance, action: :update_balance
      patch :points, action: :update_points
    end
  end
end

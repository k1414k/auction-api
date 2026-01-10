Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :v1 do
    get 'user', to: 'users#my_profile'
  end
end

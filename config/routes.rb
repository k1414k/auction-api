Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }

  # get "up" => "rails/health#show", as: :rails_health_check
  # get "/health", to: "health#index"

  # Defines the root path route ("/")
end

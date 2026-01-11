class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  before_action :config_permitted_params, :remove_internal_devise_params, if: :devise_controller?

  protected
  def config_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :nickname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def remove_internal_devise_params
    params.delete(:registration)
    params.delete(:session)
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def configure_devise_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up)        << [:first_name, :last_name]
    devise_parameter_sanitizer.permit(:account_update) << [:first_name, :last_name]
  end
end

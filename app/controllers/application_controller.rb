class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  helper_method :subnav,
                :admin?

  def subnav; end

  def admin?
    false
  end

  def configure_devise_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(*params_for_signup) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(*params_for_account_update) }
  end

  def params_for_signup
    [ :first_name, :last_name, :email, :password, :password_confirmation ]
  end

  def params_for_account_update
    [ :first_name, :last_name, :email, :password, :password_confirmation, :current_password ]
  end
end

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  before_action :set_registration_presenter,
                                            only: [:edit, :update]

  protected

  def after_update_path_for(resource)
    edit_registration_path(resource)
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(*allowed_parameters) }
  end

  def allowed_parameters
    [ :first_name,
      :last_name,
      :email,
      :current_password,
      :password,
      :password_confirmation ]
  end

  def update_resource(resource, params)
    if params[:password].blank?
      resource.update_without_password(params)
    elsif resource.password_set?
      resource.update_with_password(params)
    else
      resource.update_with_first_password(params)
    end
  rescue StandardError => e
    flash[:alert] = 'There was an error with your request.'
    Rails.logger.error(e.message)
  end

  def current_user
    @current_user ||= super && User.for_review.find(@current_user.id)
  end

  def set_registration_presenter
    @presenter = RegistrationsPresenter.new(current_user, view_context)
  end
end

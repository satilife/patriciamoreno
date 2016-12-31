class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :redirect_on_oauth_error,
                :add_identity_to_existing_user,
                :set_user_from_identity

  def facebook
    authenticate_user_from 'Facebook'
  end

  def google_oauth2
    authenticate_user_from 'Google'
  end

  private

  def authenticate_user_from(provider)
    if user_signed_in?
      redirect_to edit_user_registration_path(current_user)
    else
      sign_in_and_redirect @user, event: :authentication
    end
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end

  def redirect_on_oauth_error
    return unless request.env.key?('omniauth.error')
    logger.error request.env['omniauth.error']
    handle_error(generic_error_message)
  end

  def generic_error_message
    'Sorry, your request could not be completed due to an error.'
  end

  def auth
    request.env['omniauth.auth']
  end

  def add_identity_to_existing_user
    return unless user_signed_in?
    current_user.add_omniauth(auth)
  end

  def set_user_from_identity
    return if user_signed_in?

    @user = User.from_omniauth(auth)
    @user.save! unless @user.persisted?
  rescue => error
    handle_error(error.message)
  end

  def handle_error(message)
    flash.alert = message
    redirect_to new_user_session_path
  end
end

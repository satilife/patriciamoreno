module Authenticatable
  extend ActiveSupport::Concern

  included do
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  end

  module ClassMethods
    def from_omniauth(auth)
      identity = Identity.from_omniauth(auth)
      return identity.user unless identity.user.nil?

      user = where(email: auth.info.email).first_or_create do |user|
        user.password_set = false
        user.password     = Devise.friendly_token[0,20]
        user.first_name   = auth.info.first_name
        user.last_name    = auth.info.last_name
        user.avatar       = auth.info.image
      end

      identity.update!(user: user)
      user
    end
  end

  def add_omniauth(auth)
    identity = Identity.from_omniauth(auth)
    unless identity.user == self
      raise Exceptions::IdentityExistsError unless identity.user.nil?
      identity.update!(user: self)
    end
    identity
  end

  def update_with_first_password(params, *options)
    raise Exceptions::PasswordAlreadySetError if password_set?
    if params[:password_confirmation].blank?
      params.delete(:password_confirmation)
    elsif params[:password] != params[:password_confirmation]
      raise ActiveRecord::RecordInvalid.new(self)
    else
      params[:password_set] = true
    end

    result = update_attributes!(params, *options)
    clean_up_passwords
    result
  end
end

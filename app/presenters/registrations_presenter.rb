class RegistrationsPresenter < BasePresenter
  presents :user

  IDENTITY_PARTIAL ||= 'devise/registrations/identity'

  def show_password_change?
    password_set? || !identities?
  end

  def facebook_row
    view.render IDENTITY_PARTIAL, enabled: facebook?, link: facebook_link, label: 'Facebook'
  end

  def google_row
    view.render IDENTITY_PARTIAL, css_class: :google, enabled: google?, link: google_link, label: 'Google'
  end

  private

  delegate :password_set?, to: :user

  def link(enabled, provider, path)
    if enabled
      view.link_to 'Disable', view.identity_path(provider), class: "#{link_classes} btn-danger", method: :delete, data: { confirm: 'Are you sure?' }
    else
      view.link_to 'Enable', path, class: "#{link_classes} btn-success"
    end
  end

  def link_classes
    'btn btn-xs pull-right'
  end

  def facebook_link
    link(facebook, :facebook, view.user_facebook_omniauth_authorize_path)
  end

  def google_link
    link(google, :google_oauth2, view.user_google_oauth2_omniauth_authorize_path)
  end

  def facebook
    @facebook ||= identities.find { |i| i.provider == 'facebook' }
  end

  def google
    @google ||= identities.find { |i| i.provider == 'google_oauth2' }
  end

  def identities?
    identities.any?
  end

  def facebook?
    facebook.present?
  end

  def google?
    google.present?
  end

  def identities
    @identities ||= user.identities
  end
end

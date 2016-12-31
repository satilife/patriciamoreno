module FlashHelper
  def flash_message(page_specific: , flash:, css_class:, template: 'shared/alert')
    if content_for?(page_specific)
      render template, css_class: css_class, message: (flash.present? ? "#{flash} | " : "") + content_for(page_specific)
    elsif flash
      render template, css_class: css_class, message: flash
    end
  end

  def devise_error_messages
    return unless devise_controller?
    return if controller_name == 'registrations'
    return if resource.errors.empty?

    messages = resource.errors.full_messages.join(', ').html_safe
    render 'shared/alert', css_class: :danger, message: messages
  end
end

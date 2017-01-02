class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    mail = super
    if record.password_set?
      mail.subject = 'Reset your soul.camp password!'
    else
      mail.subject = 'Create your soul.camp account!'
    end
    mail
  end
end

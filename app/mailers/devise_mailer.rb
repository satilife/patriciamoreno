class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    mail = super
    if record.password_set?
      mail.subject = 'Reset your patriciamoreno.com password!'
    else
      mail.subject = 'Create your patriciamoreno.com account!'
    end
    mail
  end
end

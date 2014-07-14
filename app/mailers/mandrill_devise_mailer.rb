class MandrillDeviseMailer < Devise::Mailer
  include Devise::Mailers::Helpers
  include Devise::Controllers::UrlHelpers

  default from: 'noreply@example.com'
  default template_name: 'empty'

  def confirmation_instructions(record, token, opts={})
    @token = token
    vars = {
      confirmation_url: confirmation_url(record, confirmation_token: @token)
    }
    mandrill_mail(record, :confirmation_instructions, vars)
  end

  def reset_password_instructions(record, token, opts={})
    @token = token
    vars = {
      edit_password_url: edit_password_url(record, reset_password_token: @token)
    }
    mandrill_mail(record, :reset_password_instructions, vars)
  end

  def unlock_instructions(record, token, opts={})
    @token = token
    vars = {
      unlock_url: unlock_url(record, unlock_token: @token)
    }
    mandrill_mail(record, :unlock_instructions, vars)
  end

private

  def mandrill_mail(record, action, vars)
    locale = record.current_locale
    variables = vars.merge(email: record.email)
    headers = {
      subject: '',
      to: variables[:email]
    }
    headers['X-MC-Template'] = EmailTemplates::TemplateNameBuilder.build(locale, action)
    headers['X-MC-MergeVars'] = variables.to_json
    mail headers
  end
end

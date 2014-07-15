class MandrillDeviseMailer < Devise::Mailer
  include Devise::Mailers::Helpers
  include Devise::Controllers::UrlHelpers

  default from: 'noreply@example.com'
  default template_name: 'empty'

  def confirmation_instructions(user, token, opts={})
    @token = token
    vars = {
      confirmation_url: confirmation_url(user, confirmation_token: @token)
    }
    mandrill_mail(user, :confirmation_instructions, vars)
  end

  def reset_password_instructions(user, token, opts={})
    @token = token
    vars = {
      edit_password_url: edit_password_url(user, reset_password_token: @token)
    }
    mandrill_mail(user, :reset_password_instructions, vars)
  end

  def unlock_instructions(user, token, opts={})
    @token = token
    vars = {
      unlock_url: unlock_url(user, unlock_token: @token)
    }
    mandrill_mail(user, :unlock_instructions, vars)
  end

private

  def mandrill_mail(user, action, vars)
    locale = user.locale
    variables = vars.merge(email: user.email)
    headers = {
      subject: '',
      to: variables[:email]
    }
    headers['X-MC-Template'] = EmailTemplates::TemplateNameBuilder.build(locale, action)
    headers['X-MC-MergeVars'] = variables.to_json
    mail headers
  end
end

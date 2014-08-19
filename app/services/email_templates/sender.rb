require 'mandrill'

module EmailTemplates
  class Sender
    attr_reader :api,
                :recipients,
                :template_name

    def initialize(recipients, template_name)
      @api = Mandrill::API.new
      @recipients = Array.wrap(recipients)
      @template_name = template_name
    end

    def send
      messages.map do |message|
        api.messages.send_template(message[:template], template_content, message[:data], async, ip_pool, send_at)
      end.flatten
    end

    def messages
      recipients_grouped_by_locale.map do |locale, _|
        {
          template: BuildTemplateName.call(locale, template_name),
          data: {
            to: Array.wrap(to(locale)),
            merge_vars: Array.wrap(merge_vars(locale)),
            from_email: from_email,
            from_name: from_name
          }
        }
      end
    end

  private

    def recipients_grouped_by_locale
      @recipients_grouped_by_locale ||= recipients.group_by(&:locale)
    end

    def template_content
      []
    end

    def to(locale)
      recipients_grouped_by_locale[locale].map(&:to)
    end

    def merge_vars(locale)
      recipients_grouped_by_locale[locale].map(&:merge_vars)
    end

    def from_email
      MandrillDeviseMailer.default_params[:from]
    end

    def from_name
       ActiveAdmin.application.site_title
    end

    def async
      true
    end

    def ip_pool
      nil
    end

    def send_at
      nil
    end
  end
end

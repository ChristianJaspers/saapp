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
      # TODO language might differ per users
      language = recipients.first.language
      mandrill_template_name = BuildTemplateName.call(language, template_name)
      api.messages.send_template(mandrill_template_name, template_content, message, async, ip_pool, send_at)
    end

    def message
      {
        to: Array.wrap(to),
        merge_vars: Array.wrap(merge_vars),
        from_email: from_email,
        from_name: from_name,
      }
    end

  private

    def template_content
      []
    end

    def to
      recipients.map(&:to)
    end

    def merge_vars
      recipients.map(&:merge_vars)
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

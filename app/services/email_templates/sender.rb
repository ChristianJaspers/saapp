require 'mandrill'

module EmailTemplates
  class Sender
    attr_reader :api,
                :recipients

    def initialize(recipients)
      @api = Mandrill::API.new
      @recipients = Array.wrap(recipients)
    end

    def send
      # TODO language might differ per users
      language = recipients.first.language
      template_name = TemplateNameBuilder.build(language, 'test')
      api.messages.send_template(template_name, template_content, message, async, ip_pool, send_at)
    end

    def message
      {
        to: Array.wrap(to),
        merge_vars: Array.wrap(merge_vars),
        from_email: from_email,
        from_name: from_name,
      }
    end

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
      'noreply@example.com'
    end

    def from_name
       ActiveAdmin.application.site_title
    end

  private

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

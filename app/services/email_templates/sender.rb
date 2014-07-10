require 'mandrill'

module EmailTemplates
  class Sender
    attr_reader :mandrill,
                :recipients

    def initialize(recipients)
      @mandrill = Mandrill::API.new Figaro.env.MANDRILL_APIKEY
      @recipients = Array.wrap(recipients)
    end

    def send
      # TODO language might differ per users
      language = recipients.first.language
      template_name = build_template_name(language, 'test')
      mandrill.messages.send_template(template_name, template_content, message, async, ip_pool, send_at)
    end

    def message
      {
        to: Array.wrap(to),
        merge_vars: Array.wrap(merge_vars)
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

  private

    def build_template_name(language, template_name)
      "#{language}-#{template_name}"
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

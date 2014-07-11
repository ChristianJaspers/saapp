require 'mandrill'

module EmailTemplates
  class Setup
    attr_reader :api

    def initialize
      @api = Mandrill::API.new
    end

    def perform
      results = []
      languages.each do |language|
        templates.each do |template|
          params = to_request_data(language, template)
          result = [language, template]
          begin
            result << api.templates.add(params[:name], nil, nil, params[:subject], params[:code], nil, params[:publish], params[:labels])
          rescue Mandrill::Error => error
            result << error
          end
          results << result
          yield *result if block_given?
        end
      end
      results
    end

  private

    def languages
      @languages ||= %w(en da)
    end

    def templates
      @templates ||= %w(
        confirmation_instructions
        reset_password_instructions
        unlock_instructions
      )
    end

    def to_request_data(language, email_template_name)
      template_name = TemplateNameBuilder.build(language, email_template_name)
      {
        name: template_name,
        subject: "Subject: #{template_name}",
        code: "<div>Please update your template #{template_name}</div>",
        publish: true,
        labels: [
          language_tag(language),
          email_template_name
        ]
      }
    end

    def language_tag(language)
      "LANG_#{language}"
    end
  end
end

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
        reset_password_instructions
      )
    end

    def to_request_data(language, email_template_name)
      template_name = BuildTemplateName.call(language, email_template_name)
      data = template_html_data(language, email_template_name)
      {
        name: template_name,
        subject: data[:subject],
        code: data[:body],
        publish: true,
        labels: [
          language_tag(language),
          email_template_name
        ]
      }
    end

    def template_html_data(language, email_template_name)
      file_path = Rails.root.join('config', 'email_templates', 'import', language, "#{email_template_name}.yml").to_s
      if File.exist?(file_path)
        HashWithIndifferentAccess.new(YAML.load(File.read(file_path)))
      else
        {
          subject: "TODO: #{email_template_name}",
          body: "<div>Please update your template #{email_template_name}</div>"
        }
      end
    end

    def language_tag(language)
      "LANG_#{language}"
    end
  end
end

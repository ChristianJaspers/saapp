module EmailTemplates
  class TemplateNameBuilder
    def self.build(language, email_template_name)
      "#{language}-#{email_template_name}"
    end
  end
end

module EmailTemplates
  class BuildTemplateName
    def self.call(language, email_template_name)
      "#{language}-#{email_template_name}"
    end
  end
end

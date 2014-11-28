module EmailTemplates
  class Recipient
    attr_accessor :locale, :email, :variables

    def initialize(locale, email, variables)
      @locale = WhitelistLocale.call(locale)
      @email = email
      @variables = variables
    end

    def to
      {
        type: 'bcc',
        email: email
      }
    end

    def merge_vars
      {
        rcpt: email,
        vars: variables.inject([]) do |agg, (k, v)|
          agg << {
            name: k.to_s,
            content: v
          }
        end
      }
    end
  end
end

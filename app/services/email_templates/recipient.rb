module EmailTemplates
  class Recipient < Struct.new(:locale, :email, :variables)
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

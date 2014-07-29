module Gamification
  module Gamified
    extend ActiveSupport::Concern

    def current_user
      User.current
    end

    module ClassMethods
      def gamify(event, options = {})
        event_subklass_name = if options[:as]
                                options[:as].to_s.classify
                                else
                                "#{self.class.name.demodulize}#{event.to_s.classify}"
                                end

        after_create ->(object) { "Gamification::Events::#{event_subklass_name}".constantize.call(object) }
      end
    end
  end
end

module Saasy
  module ApiModules
    class Subscription
      def intialize(fastspring)
        @fastspring = fastspring
      end

      def find(reference_number)
        fastspring.get_subscription(reference_number)
      end

      private

      attr_reader :fastspring
    end
  end
end

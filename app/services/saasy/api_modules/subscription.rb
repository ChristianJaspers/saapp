module Saasy
  module ApiModules
    class Subscription
      def initialize(fastspring)
        @fastspring = fastspring
      end

      def find(reference_number)
        fastspring.get_subscription(reference_number)
      end

      def update_quantity(reference_number, quantity)
        remote_subscription = find(reference_number)
        remote_subscription.quantity = quantity
        fastspring.update_subscription(remote_subscription)
      end

      private

      attr_reader :fastspring
    end
  end
end

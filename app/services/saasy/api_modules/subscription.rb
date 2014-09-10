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
        remote_subscription_update = FsprgSubscriptionUpdate.new(reference_number)
        remote_subscription_update.quantity = quantity.to_s
        fastspring.update_subscription(remote_subscription_update)
      end

      private

      attr_reader :fastspring
    end
  end
end

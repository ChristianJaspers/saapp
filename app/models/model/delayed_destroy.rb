module Model
  module DelayedDestroy
    extend ActiveSupport::Concern

    included do
      default_scope -> { where(remove_at: nil) }
    end

    def remove!
      update_column(:remove_at, Date.today + lifetime_before_is_removed)
    end

    def lifetime_before_is_removed
      30.days
    end

    module ClassMethods
      def purge_outdated_entries!
        unscoped.where('remove_at <= ?', Date.today.to_s(:db)).destroy_all
      end
    end
  end
end

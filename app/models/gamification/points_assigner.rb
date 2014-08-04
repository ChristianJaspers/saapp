module Gamification
  class PointsAssigner
    attr_reader :object, :points_to_assign, :options

    def initialize(*args)
      @points_to_assign = args.shift
      @options = args.extract_options!
    end

    def call(object, event_name)
      @object = object
      return if skip?

      beneficiary.scorings.create(amount: points, event_name: event_name) if beneficiary
    end

    private

    def beneficiary
      case options[:to]
      when Symbol then
        object.public_send(options[:to])
      when Proc then
        options[:to].call(object)
      else
        object.current_user
      end
    end

    def skip?
      return false unless condition.present?

      case condition
      when Symbol then
        !object.public_send(condition)
      when Proc then
        condition.call(object)
      else
        !!condition
      end
    end

    def condition
      options[:if]
    end

    def points
      if points_to_assign.is_a? Proc
        block.call(object)
      else
        points_to_assign
      end
    end
  end
end

module Gamification
  module Events
    class Base
      cattr_accessor :point_assigners
      @@point_assigners = []

      attr_reader :object

      def self.grant_points(*args)
        point_assigners.push(Gamification::PointsAssigner.new(*args))
      end

      def self.call(object)
        new(object).call
      end

      def initialize(object)
        @object = object
      end

      def call
        self.class.point_assigners.each do |points_assigner|
          points_assigner.call(object, self.class.name.demodulize.underscore)
        end
      end
    end
  end
end

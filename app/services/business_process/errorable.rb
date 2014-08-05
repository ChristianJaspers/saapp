module BusinessProcess
  module Errorable
    extend ActiveSupport::Concern

    included do
    end

    attr_accessor :error

    def success?
      error.blank?
    end

    def result
      error ? error : super
    end

    private

    def check_for_error(error_when_fail)
      if yield
        true
      else
        self.error = error_when_fail
        false
      end
    end
  end
end

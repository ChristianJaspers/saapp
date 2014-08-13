module BusinessProcess
  module Transactional
    def call(parameter_object, options={})
      new(parameter_object, options).tap do |business_process|
        business_process.instance_eval do
          @@transaction_model.transaction do
            self.result = call
            raise ActiveRecord::Rollback unless success?
          end
        end
      end
    end

    def transaction_for(model)
      @@transaction_model = model
    end
  end
end

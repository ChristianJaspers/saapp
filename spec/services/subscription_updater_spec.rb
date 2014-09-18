require 'rails_helper'

describe SubscriptionUpdater do
  describe '.call' do
    let(:parameter_object) { double(company: company) }
    let(:perform) { described_class.call(parameter_object) }

    pending
  end
end

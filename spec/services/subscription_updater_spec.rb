require 'rails_helper'

describe SubscriptionUpdater do
  describe '.call' do
    let(:parameter_object) { double(user: user) }
    let(:perform) { described_class.call(parameter_object) }

    pending
  end
end

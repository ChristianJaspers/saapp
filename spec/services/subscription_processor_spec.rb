require 'rails_helper'

describe SubscriptionProcessor do
  describe '.call' do
    let(:parameter_object) { double(params: params) }
    let(:perform) { described_class.call(parameter_object) }

    pending
  end
end

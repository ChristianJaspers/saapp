require 'rails_helper'

describe SubscriptionProcessor do
  describe '.call' do
    let(:manager) { create(:user, :manager) }
    let(:parameter_object) { double(params: params) }
    let(:perform) { described_class.call(parameter_object) }

    context 'valid params' do
      let(:params) do
        {
          'SubscriptionReferrer' => manager.id
        }
      end

      pending
    end
  end
end

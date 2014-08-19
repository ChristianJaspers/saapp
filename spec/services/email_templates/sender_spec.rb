require 'rails_helper'

shared_examples 'mandrill bulk message' do
  it { expect(messages).to have(1).item }
  it { expect(messages.first[:to]).to eq message_to }
  it { expect(messages.first[:merge_vars]).to eq message_vars }
  it { expect(messages.first[:from_email]).to eq 'noreply@example.com' }
  it { expect(messages.first[:from_name]).to eq 'BetterSalesman' }
end

describe EmailTemplates::Sender do
  subject { described_class.new(recipients, 'test') }

  describe '#messages' do
    let(:messages) { subject.messages }

    context 'one recipient is defined' do
      let(:recipients) { [EmailTemplates::Recipient.new('en', 'a@example.com', {name: 'Someone'})] }

      it_behaves_like 'mandrill bulk message' do
        let(:message_to) do
          [
            {type: 'bcc', email: 'a@example.com'}
          ]
        end
        let(:message_vars) do
          [
            {rcpt: 'a@example.com', vars: [{name: 'name', content: 'Someone'}]}
          ]
        end
      end
    end

    context 'two recipients are defined' do
      let(:recipients) do
        [
          EmailTemplates::Recipient.new('en', 'a@example.com', {name: 'Someone'}),
          EmailTemplates::Recipient.new('da', 'b@example.com', {name: 'Other'})
        ]
      end

      it_behaves_like 'mandrill bulk message' do
        let(:message_to) do
          [
            {type: 'bcc', email: 'a@example.com'},
            {type: 'bcc', email: 'b@example.com'}
          ]
        end
        let(:message_vars) do
          [
            {rcpt: 'a@example.com', vars: [{name: 'name', content: 'Someone'}]},
            {rcpt: 'b@example.com', vars: [{name: 'name', content: 'Other'}]}
          ]
        end
      end
    end
  end

  describe '#send' do
    let(:recipients) { [EmailTemplates::Recipient.new('en', 'test@example.com', {name: 'Someone'})] }
    let(:perform) { subject.send }

    it 'mail is queued' do
      expect(perform.to_json).to be_json_eql(
        <<-EOS
          [
            {
              "email": "test@example.com",
              "status": "sent",
              "reject_reason": null
            }
          ]
        EOS
      ).excluding('_id')
    end
  end
end

require 'rails_helper'

shared_examples 'mandrill bulk message' do
  it { expect(messages).to have(1).item }
  it { expect(messages.first[:template]).to eq 'en-test' }
  it { expect(messages.first[:data][:to]).to eq message_to }
  it { expect(messages.first[:data][:merge_vars]).to eq message_vars }
  it { expect(messages.first[:data][:from_email]).to eq 'noreply@example.com' }
  it { expect(messages.first[:data][:from_name]).to eq 'BetterSalesman' }
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
          EmailTemplates::Recipient.new('en', 'b@example.com', {name: 'Other'})
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

    context 'two recipients with different locale are defined' do
      let(:recipients) do
        [
          EmailTemplates::Recipient.new('en', 'a@example.com', {name: 'Someone'}),
          EmailTemplates::Recipient.new('da', 'b@example.com', {name: 'Other'})
        ]
      end
      let(:message_to_en) do
        [
          {type: 'bcc', email: 'a@example.com'}
        ]
      end
      let(:message_to_da) do
        [
          {type: 'bcc', email: 'b@example.com'}
        ]
      end
      let(:message_vars_en) do
        [
          {rcpt: 'a@example.com', vars: [{name: 'name', content: 'Someone'}]}
        ]
      end
      let(:message_vars_da) do
        [
          {rcpt: 'b@example.com', vars: [{name: 'name', content: 'Other'}]}
        ]
      end

      it { expect(messages).to have(2).items }

      it { expect(messages.first[:template]).to eq 'en-test' }
      it { expect(messages.first[:data][:to]).to eq message_to_en }
      it { expect(messages.first[:data][:merge_vars]).to eq message_vars_en }
      it { expect(messages.first[:data][:from_email]).to eq 'noreply@example.com' }
      it { expect(messages.first[:data][:from_name]).to eq 'BetterSalesman' }

      it { expect(messages.second[:template]).to eq 'da-test' }
      it { expect(messages.second[:data][:to]).to eq message_to_da }
      it { expect(messages.second[:data][:merge_vars]).to eq message_vars_da }
      it { expect(messages.second[:data][:from_email]).to eq 'noreply@example.com' }
      it { expect(messages.second[:data][:from_name]).to eq 'BetterSalesman' }
    end
  end

  describe '#send' do
    let(:perform) { subject.send }

    context 'single recipient' do
      let(:recipients) { [EmailTemplates::Recipient.new('en', 'test@example.com', {name: 'Someone'})] }

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

    context 'multiple recipients with different locales' do
      let(:recipients) do
        [
          EmailTemplates::Recipient.new('en', 'a@example.com', {name: 'Someone'}),
          EmailTemplates::Recipient.new('da', 'b@example.com', {name: 'Other'})
        ]
      end

      it 'mails are queued' do
        expect(perform.to_json).to be_json_eql(
          <<-EOS
            [
              {
                "email": "a@example.com",
                "status": "sent",
                "reject_reason": null
              },
              {
                "email": "b@example.com",
                "status": "sent",
                "reject_reason": null
              }
            ]
          EOS
        ).excluding('_id')
      end
    end
  end
end

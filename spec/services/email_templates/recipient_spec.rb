require 'rails_helper'

describe EmailTemplates::Recipient do
  subject { described_class.new(language, email, variables) }
  let(:language) { 'en' }
  let(:email) { 'x@example.com' }
  let(:variables) do
    {
      var_1: 'abc',
      var_2: 'xyz'
    }
  end

  describe '#to' do
    let(:perform) { subject.to }
    it 'maps recipient to mandrill params' do
      expect(perform).to eq({
        type: 'bcc',
        email: 'x@example.com'
      })
    end
  end

  describe '#merge_vars' do
    let(:perform) { subject.merge_vars }
    it 'maps variables to mandrill merge variables' do
      expect(perform).to eq({
        rcpt: 'x@example.com',
        vars: [
          {
            name: 'var_1',
            content: 'abc'
          },
          {
            name: 'var_2',
            content: 'xyz'
          }
        ]
      })
    end
  end
end

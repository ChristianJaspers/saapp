require 'rails_helper'

describe MandrillDeviseMailer do
  subject { mail }
  let(:email) { 'test@example.com' }
  let(:user) { create(:user, email: email) }
  let(:token) { 'abc' }

  describe '#reset_password_instructions' do
    let(:mail) { described_class.reset_password_instructions(user, token) }

    it 'subject is set to empty to not overwrite madrill subject' do
      expect(mail.subject).to be_nil
    end

    it 'correct template for mandrill is set' do
      expect(mail['X-MC-Template'].value).to eq 'en-reset_password_instructions'
    end

    it 'correct merge variables for mandrill are set' do
      expect(mail['X-MC-MergeVars'].value).to eq '{"edit_password_url":"http://localhost:3000/admin/password/edit?reset_password_token=abc","email":"test@example.com"}'
    end

    it 'recipient is valid' do
      expect(mail.to).to eq [user.email]
    end

    it 'sender is set to default' do
      expect(mail.from).to eq ['noreply@example.com']
    end
  end
end

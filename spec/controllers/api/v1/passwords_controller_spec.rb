require 'rails_helper'

describe Api::V1::PasswordsController do
  let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }

  describe '#create' do
    before do
      post :create, {email: email}, {format: :json}
    end

    context 'user exists' do
      let(:email) { user.email }

      it do
        expect(response).to be_successful
        expect(response.body).to be_json_eql '{}'
        expect(user.reload.reset_password_token).to be_present
      end
    end

    context 'invalid email' do
      let(:email) { 'fake@test.com' }

      it do
        expect(response.status).to eq 404
        expect(response.body).to be_json_eql <<-EOS
          {
            "error": {
              "code": 1002,
              "message": "Account not exist"
            }
          }
        EOS
      end
    end
  end
end

require 'rails_helper'

describe Api::V1::AuthController do
  let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }

  describe '#login' do
    before { post :login, params, {format: :json} }
    context 'valid credentials provided' do
      let(:params) do
        {
          email: user.email,
          password: '12345678'
        }
      end
      let(:expected_body) do
        <<-EOS
          {
            "user": {
              "id": #{user.id},
              "email": "a@a.com",
              "display_name": "Batman",
              "avatar_url": null,
              "avatar_thumb_url": null
            },
            "access_token": "#{user.access_token}"
          }
        EOS
      end

      it 'renders user with access token' do
        expect(response).to be_successful
        expect(response.body).to be_json_eql expected_body
      end
    end

    context 'invalid credentials provided' do
      let(:params) do
        {
          email: user.email,
          password: 'invalid-password'
        }
      end
      let(:expected_body) do
        <<-EOS
          {
            "error": {
              "code": 1003,
              "message": "Can not login"
            }
          }
        EOS
      end

      it 'renders error' do
        expect(response.status).to eq 401
        expect(response.body).to be_json_eql expected_body
      end
    end
  end

  describe '#forgot_password' do
    before do
      post :forgot_password, {email: email}, {format: :json}
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

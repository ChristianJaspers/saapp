require 'rails_helper'

describe Api::V1::AuthController do
  let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }

  describe '#create' do
    before { post :create, params, {format: :json} }
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
end

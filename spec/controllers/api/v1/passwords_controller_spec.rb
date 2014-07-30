require 'rails_helper'

shared_examples 'an invalid password update' do
  it do
    expect(response.status).to eq 422
    expect(response.body).to be_json_eql <<-EOS
      {
        "error": {
          "code": 1108,
          "message": "Invalid password"
        }
      }
    EOS
  end
end

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

  describe '#update' do
    let(:call_request) { put :update, params, {format: :json} }

    context 'valid access token' do
      let(:api_token) { create(:api_token, user: user) }
      before do
        api_authorize_with(api_token.access_token)
        call_request
      end

      context 'valid password is sent' do
        let(:params) do
          {
            password: '12345'
          }
        end

        it do
          expect(response).to be_successful
          expect(response.body).to be_json_eql <<-EOS
            {
              "user": {
                "id": #{user.id},
                "email": "a@a.com",
                "display_name": "Batman",
                "avatar_url": null,
                "avatar_thumb_url": null,
                "experience": 0,
                "my_activity": 0,
                "my_team_activity": 0,
                "all_teams_activity": 0
              }
            }
          EOS
          expect(user.reload.valid_password?('12345')).to be_truthy
        end
      end

      context 'no password is sent' do
        let(:params) { {} }

        it_behaves_like 'an invalid password update'
      end

      context 'too short password is sent' do
        let(:params) do
          {
            password: '1234'
          }
        end

        it_behaves_like 'an invalid password update'
      end
    end

    context 'no access token' do
      let(:params) { {} }
      before { call_request }

      it do
        expect(response.status).to eq 403
        expect(response.body).to be_json_eql <<-EOS
          {
            "error": {
              "code": 1010,
              "message": "You don't have access"
            }
          }
        EOS
      end
    end
  end
end

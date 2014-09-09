require 'rails_helper'

shared_examples 'user that is not allowed to use API' do
  let(:params) do
    {
      email: user.email,
      password: '12345678'
    }
  end

  it 'user is rejected' do
    expect(response.status).to eq 401
    expect(response.body).to be_json_eql <<-EOS
      {
        "error": {
          "code": 1103,
          "message": "#{ I18n.t('api.errors.invalid_credentials') }"
        }
      }
    EOS
  end
end

describe Api::V1::AuthController do

  describe '#create' do
    before { post :create, params, {format: :json} }

    context 'user logs in' do
      let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }

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
                "avatar_thumb_url": null,
                "experience": 0,
                "my_activity": 0,
                "my_team_activity": 0,
                "all_teams_activity": 100
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
                "code": 1103,
                "message": "#{ I18n.t('api.errors.invalid_credentials') }"
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

    context 'manager logs in' do
      let(:user) { create(:user, :manager) }
      it_behaves_like 'user that is not allowed to use API'
    end

    context 'admin logs in' do
      let(:user) { create(:user, :admin) }
      it_behaves_like 'user that is not allowed to use API'
    end
  end
end

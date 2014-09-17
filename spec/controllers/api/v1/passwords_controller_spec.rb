require 'rails_helper'

shared_examples 'an invalid password update' do
  it { expect(response.status).to eq 422 }

  it do
    expect(response.body).to be_json_eql <<-EOS
      {
        "error": {
          "code": 1108,
          "message": "#{ I18n.t('api.errors.invalid_password') }"
        }
      }
    EOS
  end
end

describe Api::V1::PasswordsController do
  let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }

  describe '#create' do
    let(:call_request) { post :create, {email: email}, {format: :json} }

    context 'user exists' do
      let(:email) { user.email }

      it 'mail is sent' do
        expect_any_instance_of(ApplicationMailer).to receive(:reset_user_password)
        call_request
      end

      context 'after request' do
        before { call_request }

        it { expect(response).to be_successful }

        it { expect(response.body).to be_json_eql '{}' }
      end
    end

    context 'invalid email' do
      let(:email) { 'fake@test.com' }
      before { call_request }

      it { expect(response.status).to eq 404 }

      it do
        expect(response.body).to be_json_eql <<-EOS
          {
            "error": {
              "code": 1002,
              "message": "#{ I18n.t('api.errors.account_not_exist') }"
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

      include_context 'all subscriptions allow to use system'

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

        it { expect(response).to be_successful }

        it { expect(user.reload.valid_password?('12345')).to be_truthy }

        it do
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
                "all_teams_activity": 100
              }
            }
          EOS
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

      it_behaves_like 'api: forbidden'
    end
  end
end

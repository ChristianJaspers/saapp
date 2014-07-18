require 'rails_helper'

describe Api::V1::ProfilesController do
  let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }
  let(:api_token) { create(:api_token, user: user) }

  describe '#show' do
    context 'valid access token provided' do
      before { api_authorize_with(api_token.access_token) }

      it 'renders user profile' do
        get :show, {format: :json}
        expect(response).to be_successful
        expect(response.body).to be_json_eql <<-EOS
          {
            "user": {
              "id": #{user.id},
              "email": "a@a.com",
              "display_name": "Batman",
              "avatar_url": null,
              "avatar_thumb_url": null
            }
          }
        EOS
      end
    end

    context 'no access' do
      let(:no_access_response) do
        <<-EOS
          {
            "error": {
              "code": 1010,
              "message": "You don't have access"
            }
          }
        EOS
      end
      before { get :show, {format: :json} }

      context 'no access token provided' do
        it do
          expect(response.status).to eq 403
          expect(response.body).to be_json_eql no_access_response
        end
      end

      context 'invalid access token provided' do
        before { api_authorize_with('wrong-access-token') }
        it do
          expect(response.status).to eq 403
          expect(response.body).to be_json_eql no_access_response
        end
      end
    end
  end

  describe '#avatar' do
    let(:perform) { post :avatar, file: subject }
    subject { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/files/avatar.png'), 'image/png') }

    context 'valid access token provided' do
      before { api_authorize_with(api_token.access_token) }
      before { perform }

      it 'uploads file' do
        expect(response).to be_successful
        expect(response.body).to be_json_eql <<-EOS
          {
            "user": {
              "id": #{user.id},
              "email": "a@a.com",
              "display_name": "Batman",
              "avatar_url": "/test/system/users/avatars/#{user.id}/original/avatar.png",
              "avatar_thumb_url": "/test/system/users/avatars/#{user.id}/thumb/avatar.png"
            }
          }
        EOS
      end

      context 'invalid mime type' do
        pending
      end

      context 'no param provided' do
        subject { nil }

        it 'upload fails' do
          expect(response.status).to eq 422
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1020,
                "message": "Can't upload"
              }
            }
          EOS
        end
      end

      context 'to big file' do
        pending
      end
    end

    context 'no access' do
      it 'renders unauthorized' do
        perform
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

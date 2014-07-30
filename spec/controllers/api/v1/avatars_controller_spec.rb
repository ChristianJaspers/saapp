require 'rails_helper'

describe Api::V1::AvatarsController do
  let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }
  let(:api_token) { create(:api_token, user: user) }

  describe '#update' do
    let(:perform) { put :update, file: subject }
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
              "avatar_thumb_url": "/test/system/users/avatars/#{user.id}/thumb/avatar.png",
              "my_activity": 0,
              "my_team_activity": 0,
              "all_teams_activity": 0
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

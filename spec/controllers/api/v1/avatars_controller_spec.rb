require 'rails_helper'

describe Api::V1::AvatarsController do
  let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }
  let(:api_token) { create(:api_token, user: user) }

  describe '#update' do
    let(:perform) { put :update, file: subject }
    subject { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/files/#{file}"), mime) }

    context 'valid access token provided' do
      let(:file) { 'avatar.png' }
      let(:mime) { 'image/png' }

      include_context 'all subscriptions allow to use system'

      before { api_authorize_with(api_token.access_token) }

      context 'valid file provided' do
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
                "experience": 0,
                "my_activity": 0,
                "my_team_activity": 0,
                "all_teams_activity": 100
              }
            }
          EOS
        end
      end

      context 'invalid mime type' do
        let(:file) { 'text.txt' }
        let(:mime) { 'text/plain' }
        before { perform }

        it 'upload is rejected' do
          expect(response.status).to eq 422
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1105,
                "message": "#{ I18n.t('api.errors.invalid_file_type') }"
              }
            }
          EOS
        end
      end

      context 'no param provided' do
        subject { nil }
        before { perform }

        it 'upload fails' do
          expect(response.status).to eq 422
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1106,
                "message": "#{ I18n.t('api.errors.invalid_file_parameter') }"
              }
            }
          EOS
        end
      end

      context 'file is too big' do
        before do
          allow_any_instance_of(User).to receive(:avatar_file_size).and_return(50.megabytes)
          perform
        end

        it do
          expect(response.status).to eq 422
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1107,
                "message": "#{ I18n.t('api.errors.file_is_too_big') }"
              }
            }
          EOS
        end
      end
    end

    context 'no access' do
      let(:file) { 'avatar.png' }
      let(:mime) { 'image/png' }

      before { perform }

      it_behaves_like 'api: forbidden'
    end
  end
end

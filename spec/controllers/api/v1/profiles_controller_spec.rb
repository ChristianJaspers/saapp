require 'rails_helper'

describe Api::V1::ProfilesController do
  let(:user) { create(:user, display_name: 'Batman', email: 'a@a.com') }
  let(:api_token) { create(:api_token, user: user) }

  describe '#show' do
    context 'valid access token provided' do
      before { api_authorize_with(api_token.access_token) }

      it 'renders user profile' do
        get :show, {format: :json}
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
        it { expect(response.body).to be_json_eql no_access_response }
      end

      context 'invalid access token provided' do
        before { api_authorize_with('wrong-access-token') }
        it { expect(response.body).to be_json_eql no_access_response }
      end
    end
  end

  describe '#avatar' do
    pending
  end
end

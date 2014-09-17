require 'rails_helper'

describe Api::V1::ArgumentsController do
  before { travel_to(Time.new(2014, 7, 30, 12, 0, 0, "+00:00")) }
  after { travel_back }
  let!(:product_group) { create(:product_group, name: "Group A") }
  let!(:current_user) { create(:user, display_name: 'Batman', email: 'batman@cave.com', team: product_group.owner.team) }
  let!(:api_token) { create(:api_token, user: current_user) }

  describe '#create' do
    let(:call_request) { post :create, params, format: 'json' }

    context 'valid api token' do
      include_context 'all subscriptions allow to use system'

      before do
        api_authorize_with(api_token.access_token)
        call_request
      end

      context 'valid params' do
        let(:params) do
          {
            feature: 'F',
            benefit: 'B',
            product_group_id: product_group.id
          }
        end

        it { expect(response.status).to eq 201 }
        it { expect(response.body).to have_json_type(Integer).at_path 'argument/id' }
        it { expect(response.body).to have_json_type(String).at_path 'argument/created_at' }
        it { expect(response.body).to have_json_type(String).at_path 'argument/updated_at' }
        it { expect(response.body).to have_json_type(Integer).at_path 'user/id' }

        it do
          expect(response.body).to be_json_eql(<<-EOS
            {
              "argument": {
                "user_id": #{current_user.id},
                "product_group_id": #{product_group.id},
                "rating": 0.0,
                "my_rating": 0,
                "feature": "F",
                "benefit": "B"
              },
              "user": {
                "display_name": "#{current_user.display_name}",
                "email": "#{current_user.email}",
                "avatar_url": null,
                "avatar_thumb_url": null,
                "experience": 9,
                "my_activity": 50,
                "my_team_activity": 100,
                "all_teams_activity": 100
              }
            }
          EOS
          ).excluding(:id, :created_at, :updated_at)
        end
      end

      context 'missing product group param' do
        let(:params) do
          {
            feature: 'F',
            benefit: 'B'
          }
        end

        it { expect(response.status).to eq 422 }

        it do
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1109,
                "message": "#{ I18n.t('api.errors.missing_product_group') }"
              }
            }
          EOS
        end
      end

      context 'missing feature param' do
        let(:params) do
          {
            benefit: 'B',
            product_group_id: product_group.id
          }
        end

        it { expect(response.status).to eq 422 }

        it do
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1110,
                "message": "#{ I18n.t('api.errors.missing_feature_or_benefit') }"
              }
            }
          EOS
        end
      end

      context 'missing benefit param' do
        let(:params) do
          {
            feature: 'F',
            product_group_id: product_group.id
          }
        end

        it { expect(response.status).to eq 422 }

        it do
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1110,
                "message": "#{ I18n.t('api.errors.missing_feature_or_benefit') }"
              }
            }
          EOS
        end
      end
    end

    context 'invalid api token' do
      before { call_request }
      let(:params) { {} }

      it_behaves_like 'api: forbidden'
    end
  end

  describe '#update' do
    let!(:argument) { create(:argument, product_group: product_group, owner: current_user) }
    let(:call_request) { put :update, params.merge(id: id), format: 'json' }

    context 'valid api token' do
      include_context 'all subscriptions allow to use system'

      before { api_authorize_with(api_token.access_token) }

      context 'valid params' do
        let(:id) { argument.id }
        let(:params) do
          {
            feature: 'F',
            benefit: 'B',
            product_group_id: product_group.id
          }
        end
        before { call_request }

        it { expect(response.status).to eq 201 }
        it { expect(response.body).to have_json_type(Integer).at_path 'argument/id' }
        it { expect(response.body).to have_json_type(String).at_path 'argument/created_at' }
        it { expect(response.body).to have_json_type(String).at_path 'argument/updated_at' }
        it { expect(response.body).to have_json_type(Integer).at_path 'user/id' }

        it do
          expect(response.body).to be_json_eql(<<-EOS
            {
              "argument": {
                "user_id": #{current_user.id},
                "product_group_id": #{product_group.id},
                "rating": 0.0,
                "my_rating": 0,
                "feature": "F",
                "benefit": "B"
              },
              "user": {
                "display_name": "#{current_user.display_name}",
                "email": "#{current_user.email}",
                "avatar_url": null,
                "avatar_thumb_url": null,
                "experience": 9,
                "my_activity": 50,
                "my_team_activity": 100,
                "all_teams_activity": 100
              }
            }
          EOS
          ).excluding(:id, :created_at, :updated_at)
        end
      end

      context 'contains rating' do
        let(:id) { argument.id }

        before do
          create(:argument_rating, argument: argument)
          call_request
        end

        context 'feature is modified' do
          let(:params) { {feature: 'New F'} }
          it { expect(argument.ratings).to have(0).items }
        end

        context 'benefit is modified' do
          let(:params) { {benefit: 'New B'} }
          it { expect(argument.ratings).to have(0).items }
        end

        context 'product group id is modified' do
          let(:other_product_group) { create(:product_group, owner: product_group.owner) }
          let(:params) { {product_group_id: other_product_group} }
          it { expect(argument.ratings).to have(1).item }
        end
      end

      context 'missing argument' do
        let(:id) { argument.id + 1 }
        let(:params) { {} }
        before { call_request }

        it { expect(response.status).to eq 404 }

        it do
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1111,
                "message": "#{ I18n.t('api.errors.argument_not_found') }"
              }
            }
          EOS
        end
      end

      context 'missing product group' do
        let(:id) { argument.id }
        let(:params) do
          {
            product_group_id: product_group.id + 1
          }
        end
        before { call_request }

        it { expect(response.status).to eq 422 }

        it do
          expect(response.body).to be_json_eql <<-EOS
            {
              "error": {
                "code": 1109,
                "message": "#{ I18n.t('api.errors.missing_product_group') }"
              }
            }
          EOS
        end
      end
    end

    context 'different owner' do
      let(:id) { argument.id }
      let(:other_user) { create(:user, team: current_user.team) }
      let(:params) do
        {
          feature: 'F2'
        }
      end

      before do
        api_authorize_with(other_user.access_token)
        call_request
      end

     it_behaves_like 'api: forbidden'
    end

    context 'invalid api token' do
      let(:id) { argument.id }
      let(:params) { {} }

      before { call_request }

      it_behaves_like 'api: forbidden'
    end
  end
end

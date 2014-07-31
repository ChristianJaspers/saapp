require 'rails_helper'

describe Api::ArgumentSerializer do
  let(:serializer) { described_class.new(argument) }
  subject { serializer }

  context 'for current user' do
    let(:current_user) { create(:user) }
    before { allow_any_instance_of(described_class).to receive(:current_user).and_return(current_user) }

    context 'argument exists' do
      let(:argument_creator) { create(:user) }
      let(:argument) { create(:argument, owner: argument_creator) }

      context 'argument is rated with medium score by current user' do
        before { argument.ratings.create(rater: current_user, rating: :medium) }

        context 'argument attributes' do
          let(:argument_attributes) { parse_json(serializer.to_json)['argument'] }
          subject { argument_attributes }

          its(['rating']) { is_expected.to eq 2 }
          its(['my_rating']) { is_expected.to eq 2 }
          its(['user_id']) { is_expected.to eq argument_creator.id }
        end
      end

      context 'argument is rated with medium score by other user' do
        before { argument.ratings.create(rater: create(:user), rating: :medium) }

        context 'argument attributes' do
          let(:argument_attributes) { parse_json(serializer.to_json)['argument'] }
          subject { argument_attributes }

          its(['rating']) { is_expected.to eq 2 }
          its(['my_rating']) { is_expected.to eq 0 }
        end
      end
    end
  end
end

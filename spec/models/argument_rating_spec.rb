require 'rails_helper'

describe ArgumentRating do
  it { should validate_uniqueness_of(:argument_id).scoped_to(:rater_id) }

  describe '.create' do
    context 'for given argument' do
      let(:argument_creator) { create(:user) }
      let!(:argument) { create(:argument, owner: argument_creator) }

      context 'for given rater' do
        let!(:rater) { create(:user) }

        context 'argument is rated' do
          let(:rating_level){ :medium }
          let(:perform) { argument.ratings.create(rating: rating_level, rater: rater) }

          it { expect { perform }.to change { Gamification::Scoring.count }.by(2) }

          context 'after perform' do
            before { perform }

            it { expect(rater.score).to eq 5 }

            it 'argument creator is granted 9 points for creating an argument and 2 for being rated medium' do
              expect(argument_creator.score).to eq 11
            end

            context 'argument is rated high' do
              let(:rating_level){ :high }

              it 'argument creator is granted 9 points for creating an argument and 4 for being rated high' do
                expect(argument_creator.score).to eq 13
              end
            end

            context 'argument is rated low' do
              let(:rating_level){ :low }

              it 'argument creator is granted 9 points for creating an argument and 0 for being rated low' do
                expect(argument_creator.score).to eq 9
              end
            end
          end

          context 'argument is rated twice' do
            before do
              argument.ratings.create(rating: :medium, rater: create(:user))
              argument.ratings.create(rating: :high, rater: create(:user))
            end

            it 'argument creator is granted 9 points for creating an argument and 6 for being rated high and medium' do
              expect(argument_creator.score).to eq 15
            end
          end
        end
      end
    end
  end
end

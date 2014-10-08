require 'rails_helper'

describe AccountActivationJobManager do
  let(:now) { Time.new(2014, 10, 10, 10, 10) }
  before { travel_to now }
  after { travel_back }

  subject { described_class.new(user) }
  let(:user) { create(:user, :manager) }

  describe '#create_job' do
    let(:perform) { subject.create_job }

    context 'after perform' do
      before { perform }

      let(:delayed_job) { Delayed::Job.last }
      let(:delayed_job_hanlder) { YAML.load(delayed_job.handler) }

      it { expect(delayed_job.run_at).to eq now + 10.minutes }
      it { expect(delayed_job.custom_user_id).to eq user.id }
      it { expect(delayed_job.custom_task_identifier).to eq 'account_activation' }
      it { expect(delayed_job_hanlder.method_name).to eq :send_confirmation_instructions }
      it { expect(delayed_job_hanlder.object).to eq user }
    end
  end

  describe '#destroy_job' do
    let(:perform) { subject.destroy_job }

    context 'delayed_job exists' do
      let!(:delayed_job) { create(:delayed_job, custom_user_id: user.id, custom_task_identifier: 'account_activation') }

      it { expect(perform).to eq [delayed_job] }
    end

    context 'delayed_job does not exist' do
      it { expect(perform).to eq [] }
    end
  end
end

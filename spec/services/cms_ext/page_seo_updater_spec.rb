require 'rails_helper'

describe CmsExt::PageSeoUpdater do
  describe '.call' do
    let(:page) { create(:comfy_cms_page) }
    let(:parameter_object) do
      double(
        params: {
          cms_page_seo_data: {
            title: 'new',
            description: 'new desc'
          }
        },
        page: page
      )
    end
    let(:perform) { described_class.call(parameter_object).success? }

    context 'page data exists' do
      let!(:old_data) { create(:cms_page_seo_data, page_id: page.id, title: 'old', description: 'old desc') }

      it { expect(perform).to be_truthy }
      it { expect { perform }.to change { old_data.reload.title }.from('old').to('new') }
      it { expect { perform }.to change { old_data.reload.description }.from('old desc').to('new desc') }
    end

    context 'page doest not exist' do
      it { expect(perform).to be_truthy }
      it { expect { perform }.to change { CmsPageSeoData.count }.by(1) }

      context 'after perform' do
        let(:seo_data) { CmsPageSeoData.last }
        before { perform }

        it { expect(seo_data.title).to eq 'new' }
        it { expect(seo_data.description).to eq 'new desc' }
        it { expect(seo_data.page_id).to eq page.id }
      end
    end
  end
end

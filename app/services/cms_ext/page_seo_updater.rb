module CmsExt
  class PageSeoUpdater < BusinessProcess::Base
    extend BusinessProcess::Transactional
    transaction_for Comfy::Cms::Page

    needs :page
    needs :params

    def call
      find_or_create_seo_data and
        update_seo_data_for_page
    end

    private

    attr_reader :seo_data

    def find_or_create_seo_data
      @seo_data ||= CmsPageSeoData.find_or_initialize_by(page_id: page.id)
    end

    def update_seo_data_for_page
      seo_data.title = params[:cms_page_seo_data][:title]
      seo_data.description = params[:cms_page_seo_data][:description]
      seo_data.save
    end
  end
end

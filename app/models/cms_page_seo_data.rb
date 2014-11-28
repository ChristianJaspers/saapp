class CmsPageSeoData < ActiveRecord::Base
  self.table_name = 'cms_page_seo_data'

  def self.data_for_page(page)
    result = if page
      CmsPageSeoData.find_by(page_id: page.id)
    end

    result || CmsPageSeoData.new
  end
end

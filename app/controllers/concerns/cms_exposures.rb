module CmsExposures
  extend ActiveSupport::Concern

  included do
    expose(:cms_site) { Comfy::Cms::Site.find_by_locale(I18n.locale) }

    expose(:cms_static_pages) do
      if cms_site
        cms_site.static_pages
      else
        []
      end
    end

    expose(:cms_page_seo_data) do
      current_page = @cms_page || (cms_site ? cms_site.root_page : nil)
      CmsPageSeoData.data_for_page(current_page)
    end

    expose(:cms_root_page_content) do
      if cms_site
        cms_site.root_page_content
      else
        ''
      end
    end

    expose(:company_subscription) do
      CompanySubscription.new(current_user)
    end
  end
end

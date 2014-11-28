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

    expose(:cms_page_title) do
      t('application_name')
    end

    expose(:cms_page_description) do
      ''
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

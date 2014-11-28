ActiveAdmin.register Comfy::Cms::Page do
  menu false

  actions :index, :edit

  index do
    id_column
    column :locale do |page|
      page.site.locale
    end
    column :label
    column :slug
    column :path do |page|
      localized_cms_page_path(page)
    end
    actions
  end

  form partial: 'form'

  controller do
    def update
      success = CmsExt::PageSeoUpdater.call(page: resource, params: params).success?
      redirect_to admin_comfy_cms_pages_path(site_id: resource.site_id), redirect_options(success)
    end

    def scoped_collection
      scope = Comfy::Cms::Page.includes(:site)
      scope = scope.where(site_id: params[:site_id]) if params[:site_id].present?
      scope
    end

    private

    def redirect_options(success)
      if success
        {notice: 'Page updated'}
      else
        {error: 'Page not updated'}
      end
    end
  end
end

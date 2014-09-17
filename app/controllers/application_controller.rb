class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include LanguageAutoredirect

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  expose(:cms_site) { Comfy::Cms::Site.find_by_locale(I18n.locale) }
  expose(:cms_static_pages) do
    if cms_site
      cms_site.static_pages
    else
      []
    end
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

  private

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_url
    elsif resource.manager?
      manager_root_url
    else
      root_url
    end
  end

  def after_sign_out_path_for(resource)
    root_url
  end

  def default_url_options(options={})
    {
      locale: (I18n.locale == I18n.default_locale) ? nil : I18n.locale
    }
  end
end

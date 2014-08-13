class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_locale

  helper_method :localized_path, :localized_current_path

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

  private

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_url
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

  def set_current_locale
    I18n.locale = params[:locale] if params[:locale]
  end

  def localized_path(locale, path)
    if locale == I18n.default_locale
      path
    else
      "/#{locale}#{path}"
    end
  end

  def localized_current_path(locale)
    localized_path(locale, '/')
  end
end

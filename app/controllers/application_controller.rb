class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_locale

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  expose(:static_pages) do
    site = Comfy::Cms::Site.find_by_locale(I18n.locale)
    pages = if site
      home_page = site.pages.find_by(slug: 'index')
      if home_page
        home_page.children.published
      else
        []
      end
    end
    Array.wrap(pages)
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
end

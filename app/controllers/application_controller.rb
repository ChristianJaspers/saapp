class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

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

  expose(:account_has_been_activated?) { @account_has_been_activated || params[:account_activation] == 'true' }

  private

  def after_sign_in_path_for(resource)
    if resource.admin? || resource.cms_editor?
      admin_root_url
    elsif resource.manager?
      if account_has_been_activated?
        manager_root_url(account_activation: true, locale: I18n.locale)
      else
        manager_root_url(locale: I18n.locale)
      end
    else
      root_url(locale: I18n.locale)
    end
  end

  def after_sign_out_path_for(resource)
    root_url(locale: I18n.locale)
  end

  def ssl_configured?
    # TO BE CHANGE WHEN MOBILE GUYS SET API URL FOR HTTPS PROTOCOL
    # !Rails.env.development?
    false
  end
end

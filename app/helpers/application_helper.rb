module ApplicationHelper
  def logged_in?
    current_user.present?
  end

  def guest?
    not logged_in?
  end

  def localized_cms_page_path(cms_page)
    "/#{cms_page.site.path}/#{cms_page.full_path}".squeeze("/")
  end

  def localized_current_path(locale)
    if locale == I18n.default_locale
      '/'
    else
      "/#{locale}"
    end
  end

  def locale_flag_filename(locale)
    "locales/#{locale}.png"
  end
end

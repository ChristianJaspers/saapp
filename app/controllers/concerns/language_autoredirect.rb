module LanguageAutoredirect
  extend ActiveSupport::Concern

  LANG_PATH_REGEX = /(?:^\/(?<lang>[a-z]{2})\/?$)|(?:^\/(?<lang>[a-z]{2})\/)/
  LANG_REGEX = /^[a-z]{2}$/

  included do
    before_action :autodetect_language
    before_action :set_current_locale

    helper_method :localized_path
  end

  private

  def save_locale(locale)
    if current_user
      current_user.locale = locale
      current_user.save!
    end
    cookies[:lang] = locale
  end

  def read_locale
    if current_user
      current_user.locale
    else
      cookies[:lang]
    end.to_s.to_sym
  end

  def autodetect_language
    return unless request.get?
    save_locale(web_browser_locale) unless cookies[:lang].present?
    redirect_to_back_with_locale(read_locale) if different_locale?
  end

  def different_locale?
    extracted_locale != read_locale
  end

  def web_browser_locale
    (http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale).to_sym
  end

  def redirect_to_back_with_locale(locale)
    redirect_to (locale == I18n.default_locale) ? raw_request_path : "/#{locale}#{raw_request_path}"
  end

  def raw_request_path
    request.path.sub(LANG_PATH_REGEX, '/')
  end

  def extracted_locale
    (
      params[:locale] ||
      LANG_PATH_REGEX.match(request.path).try(:[], :lang) ||
      I18n.default_locale
    ).to_sym
  end

  def localized_path(locale, path)
    if locale == I18n.default_locale
      path
    else
      "/#{locale}#{path}"
    end
  end

  def set_current_locale
    I18n.locale = params[:locale] if params[:locale]
  end
end

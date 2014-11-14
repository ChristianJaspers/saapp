class LanguagesController < ApplicationController
  skip_before_action :autodetect_language
  skip_before_action :set_current_locale

  def update
    if params[:lang] =~ LANG_REGEX
      lang = params[:lang].to_sym
      save_locale(lang) if I18n.available_locales.include?(lang)
    end

    url_hash = Rails.application.routes.recognize_path URI(request.referer).path
    url_hash[:locale] = read_locale
    redirect_to url_hash
  end
end

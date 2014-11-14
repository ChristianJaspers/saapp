class LanguagesController < ApplicationController
  skip_before_action :autodetect_language
  skip_before_action :set_current_locale

  def update
    if params[:lang] =~ LANG_REGEX
      lang = params[:lang].to_sym
      save_locale(lang) if I18n.available_locales.include?(lang)
    end

    url_hash = Rails.application.routes.recognize_path URI(request.referer).path
    url_hash[:only_path] = true
    redirect_to normalize_trailing_slash(
      localized_path(
        read_locale,
        raw_fullpath_from_request(url_for(url_hash))
      )
    )
  end
end

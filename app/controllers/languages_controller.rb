class LanguagesController < ApplicationController
  skip_before_action :autodetect_language
  skip_before_action :set_current_locale

  def update
    if params[:lang] =~ LANG_REGEX
      lang = params[:lang].to_sym
      save_locale(lang) if I18n.available_locales.include?(lang)
    end

    redirect_to :back
  end
end

class WhitelistLocale
  def self.call(locale)
    whitelisted_locale = (I18n.available_locales.map(&:to_s) & [locale.to_s]).first.presence || I18n.default_locale.to_s
    whitelisted_locale.to_sym
  end
end

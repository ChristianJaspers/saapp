class Api::ErrorMapping
  ERRORS = {
    not_authenticated: {
      http_code: 401,
      internal_code: 1103,
      message: 'api.errors.invalid_credentials'
    },
    forbidden: {
      http_code: 403,
      internal_code: 1010,
      message: 'api.errors.no_access'
    },
    account_not_exist: {
      http_code: 404,
      internal_code: 1002,
      message: 'api.errors.account_not_exist'
    },
    invalid_file_type: {
      http_code: 422,
      internal_code: 1105,
      message: 'api.errors.invalid_file_type'
    },
    invalid_file_parameter: {
      http_code: 422,
      internal_code: 1106,
      message: 'api.errors.invalid_file_parameter'
    },
    file_is_too_big: {
      http_code: 422,
      internal_code: 1107,
      message: 'api.errors.file_is_too_big'
    },
    invalid_password: {
      http_code: 422,
      internal_code: 1108,
      message: 'api.errors.invalid_password'
    },
    missing_product_group: {
      http_code: 422,
      internal_code: 1109,
      message: 'api.errors.missing_product_group'
    },
    missing_feature_or_benefit: {
      http_code: 422,
      internal_code: 1110,
      message: 'api.errors.missing_feature_or_benefit'
    },
    argument_not_found: {
      http_code: 404,
      internal_code: 1111,
      message: 'api.errors.argument_not_found'
    },
    argument_already_rated: {
      http_code: 422,
      internal_code: 1112,
      message: 'api.errors.argument_already_rated'
    },
    forbidden_no_subscription: {
      http_code: 403,
      internal_code: 1113,
      message: 'api.errors.no_subscription'
    }
  }

  def initialize(error_key, current_user, params = {})
    @error_key = error_key
    @user = current_user
    @params = params
    raise ArgumentError, "Error key :#{error_key} not defined" unless ERRORS[error_key]
  end

  def http_code
    ERRORS[error_key][:http_code]
  end

  def internal_code
    ERRORS[error_key][:internal_code]
  end

  def message
    I18n.t(ERRORS[error_key][:message], locale: locale)
  end

  def to_hash
    {
      error: {
        code: internal_code,
        message: message
      }
    }
  end

  def locale
    @locale ||= (locales_to_consider & I18n.available_locales).first
  end

  delegate :to_json, to: :to_hash

  private

  def locales_to_consider
    @locales_to_consider ||= [requested_locale, user_locale, I18n.default_locale].compact.map(&:to_sym)
  end

  def requested_locale
    if params && params[:device_info] && params[:device_info][:locale].present?
      params[:device_info][:locale]
    end
  end

  def user_locale
    user.try :locale
  end

  attr_reader :error_key, :params, :user
end

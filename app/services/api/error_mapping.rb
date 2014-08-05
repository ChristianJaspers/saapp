class Api::ErrorMapping
  ERRORS = {
    not_authenticated: {
      http_code: 401,
      internal_code: 1103,
      message: 'Wrong credentials'
    },
    forbidden: {
      http_code: 403,
      internal_code: 1010,
      message: 'You don\'t have access'
    },
    account_not_exist: {
      http_code: 404,
      internal_code: 1002,
      message: 'Account not exist'
    },
    invalid_file_upload: {
      http_code: 422,
      internal_code: 1020,
      message: 'Can\'t upload'
    },
    invalid_password: {
      http_code: 422,
      internal_code: 1108,
      message: 'Invalid password'
    },
    missing_product_group: {
      http_code: 422,
      internal_code: 1109,
      message: 'Missing product group'
    },
    missing_feature_or_benefit: {
      http_code: 422,
      internal_code: 1110,
      message: 'Missing feature or benefit'
    },
    argument_not_found: {
      http_code: 404,
      internal_code: 1111,
      message: 'Argument not found'
    }
  }

  def initialize(error_key, params = {})
    @error_key = error_key
    raise ArgumentError, "Error key :#{error_key} not defined" unless ERRORS[error_key]
  end

  def http_code
    ERRORS[error_key][:http_code]
  end

  def internal_code
    ERRORS[error_key][:internal_code]
  end

  def message
    ERRORS[error_key][:message]
  end

  def to_hash
    {
      error: {
        code: internal_code,
        message: message
      }
    }
  end

  delegate :to_json, to: :to_hash

  private

  attr_reader :error_key, :params
end

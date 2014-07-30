class Api::ErrorMapping
  ERRORS = {
    not_authenticated: [401, 1103, 'Wrong credentials'],
    forbidden: [403, 1010, 'You don\'t have access'],
    account_not_exist: [404, 1002, 'Account not exist'],
    invalid_file_upload: [422, 1020, 'Can\'t upload'],
    invalid_password: [422, 1108, 'Invalid password']
  }

  def initialize(error_key, params = {})
    @error_key = error_key
    raise ArgumentError, "Error key :#{error_key} not defined" unless ERRORS[error_key]
  end

  def http_code
    ERRORS[error_key][0]
  end

  def internal_code
    ERRORS[error_key][1]
  end

  def message
    ERRORS[error_key][2]
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

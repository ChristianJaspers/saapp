module User::DeviseConfirmableActivation
  extend ActiveSupport::Concern

  included do
    attr_reader :raw_confirmation_token
  end

  def attempt_set_password(params)
    update_attributes(
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
  end

  def has_no_password?
    encrypted_password.blank?
  end

  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  def password_match?
    self.password == password_confirmation
  end

  protected

  def password_required?
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end
end

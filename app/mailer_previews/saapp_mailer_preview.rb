class SaappMailerPreview
  def confirmation_instructions
    SaappMailer.confirmation_instructions record, token, opts
  end


  def reset_password_instructions
    SaappMailer.reset_password_instructions record, token, opts
  end


  def unlock_instructions
    SaappMailer.unlock_instructions record, token, opts
  end

  private

  def record
    User.new(email: 'user@example.com')
  end

  def token
    '0123456789'
  end

  def opts
    {}
  end
end

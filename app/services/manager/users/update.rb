class Manager::Users::Update < BusinessProcess::Base
  needs :user
  needs :params

  def call
    update_user and
      send_reset_password_instructions
  end

  private

  def update_user
    user.manager = params[:user][:manager] == '1'
    user.save
  end

  def send_reset_password_instructions
    user.send_reset_password_instructions if has_become_manager?
    true
  end

  def has_become_manager?
    user.previous_changes['role'] == ['user', 'manager']
  end
end

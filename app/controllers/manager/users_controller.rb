class Manager::UsersController < Manager::ManagerController
  expose_decorated(:users, ancestor: :team) { |relation| relation.order(:email).page(params[:page]) }
  expose(:user, attributes: :user_params)

  layout 'manager'

  def create
    user.skip_confirmation_notification!

    if user.save
      ApplicationMailer.user_invitation(user)
      redirect_to manager_users_path, notice: t('manager.users.create.notifications.success')
    else
      render :index
    end
  end

  def destroy
    user.remove!
    redirect_to manager_users_path, notice: t('manager.users.destroy.notifications.success')
  end

  def update
    was_manager = user.manager?
    user.manager = params[:user][:manager] == '1'
    becomes_manager = !was_manager && user.manager?

    if user.save
      user.send_reset_password_instructions if becomes_manager
      redirect_to manager_users_path, notice: t('manager.users.update.notifications.success')
    else
      render :edit
    end
  end

  private

  def team
    current_user.team
  end

  def user_params
    params.require(:user).permit(:display_name, :email)
  end
end

class Manager::UsersController < Manager::ManagerController
  expose_decorated(:users, ancestor: :team) { |relation| relation.order(:email).page(params[:page]) }
  expose(:user, attributes: :user_params)

  layout 'manager'

  def create
    if Manager::CreateUser.call(self).success?
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
    if Manager::UpdateUser.call(self).success?
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
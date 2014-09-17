class Manager::ProfilesController < Manager::ManagerController
  expose(:sales_reps_count) { current_user.team.sales_representatives.count }

  def update
    current_user.attributes = user_params
    if current_user.save
      redirect_to edit_manager_profile_path, notice: t('manager.profile.update.notifications.success')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:display_name, :address)
  end
end

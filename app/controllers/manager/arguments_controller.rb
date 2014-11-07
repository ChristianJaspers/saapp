class Manager::ArgumentsController < Manager::ManagerController
  def destroy
    success = Manager::DestroyArgument.call(self).success?
    redirect_to :back, notice: (success ? t('manager.arguments.destroy.notifications.success') : t('manager.arguments.destroy.notifications.failure'))
  end
end

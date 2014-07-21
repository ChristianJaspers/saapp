class Manager::ManagerController < ApplicationController
  before_action :authorize_manager!

  private

  def authorize_manager!
    redirect_to root_path, notice: t('common.unauthorized') unless current_user.manager?
  end
end

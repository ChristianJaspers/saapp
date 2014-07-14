class WizardsController < ApplicationController
  expose(:wizard)

  def new
    render 'home/show' unless wizard.valid?
    gon.email = wizard.email
  end

  def create
    redirect_to root_path, notice: t('wizard.create.notifications.success')
  end
end

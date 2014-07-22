class WizardsController < ApplicationController
  expose(:wizard, strategy: DecentExposure::ActiveRecordWithEagerAttributesStrategy)
  protect_from_forgery except: :create

  def new
    render 'home/show' unless wizard.valid?
    gon.email = wizard.email
  end

  def create
    SetupNewAccount.call(self)

    flash[:notice] = t('wizard.create.notifications.success')
    render json: 'success', status: :created
  end
end

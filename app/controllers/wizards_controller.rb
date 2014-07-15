class WizardsController < ApplicationController
  expose(:wizard)
  protect_from_forgery except: :create

  def new
    render 'home/show' unless wizard.valid?
    gon.email = wizard.email
  end

  def create
    flash[:notice] = t('wizard.create.notifications.success')
    render json: 'success', status: :created
  end
end

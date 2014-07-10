class WizardsController < ApplicationController
  expose(:wizard)

  def create
    render 'home/show' unless wizard.valid?
    gon.email = wizard.email
  end
end

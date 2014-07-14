class WizardsController < ApplicationController
  expose(:wizard)

  def new
    render 'home/show' unless wizard.valid?
    gon.email = wizard.email
  end
end

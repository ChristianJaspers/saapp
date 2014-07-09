class WizardsController < ApplicationController
  expose(:wizard)

  def create
    render 'home/show' unless wizard.valid?
  end
end

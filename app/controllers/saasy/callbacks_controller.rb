class Saasy::CallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :autodetect_language
  skip_before_action :set_current_locale

  before_action :authenticate_saasy!

  def create
    api = Saasy::Api.new
    subscription = api.subscription.find(params[:reference])
    binding.pry
    head :ok
  end

  private

  def authenticate_saasy!
    render status: :forbidden unless Saasy::Api.authenticate_callback?(params[:security_data], params[:security_hash])
  end
end

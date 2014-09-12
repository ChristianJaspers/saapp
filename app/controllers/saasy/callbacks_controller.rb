class Saasy::CallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :authenticate_saasy!

  def create
    SubscriptionProcessor.call(self) unless params[:OrderID].present?
    head :ok
  end

  private

  def authenticate_saasy!
    render status: :forbidden if !Rails.env.development? || !Saasy::Api.authenticate_callback?(params[:security_data], params[:security_hash])
  end
end

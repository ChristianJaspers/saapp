class Saasy::CallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :load_cms_site, :load_cms_page, :load_cms_layout

  before_action :authenticate_saasy!

  def create
    SubscriptionProcessor.call(self) unless params[:OrderID].present?
    head :ok
  end

  private

  def authenticate_saasy!
    render text: '', status: :forbidden if !Saasy::Api.authenticate_callback?(params[:security_data], params[:security_hash])
  end
end

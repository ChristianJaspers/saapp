class Saasy::SubscriptionsController < ApplicationController
  def show
    redirect_to Saasy::Api.new.subscription.management_url(params[:id])
  end
end

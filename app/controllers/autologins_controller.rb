class AutologinsController < ApplicationController
  def login
    user = ::Autologin.authenticate_user(params[:id])
    if user
      sign_in(:user, user)
      redirect_to after_sign_in_path_for(user)
    else
      redirect_to :back
    end
  end
end

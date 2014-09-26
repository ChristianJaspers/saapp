class SessionsController < Devise::SessionsController
  def create
    super do |resource|
      # if company_subscription.any_remote_subscription
      #   unless company_subscription.active_remote_subscription
      #     sign_out :user
      #   end
      # end
    end
  end
end

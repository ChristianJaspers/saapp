class Manager::DestroyProductGroup < BusinessProcess::Base
  extend BusinessProcess::Transactional
  transaction_for ProductGroup

  needs :product_group
  needs :current_user

  def call
    remove_product_group_and_send_notification
  end

  private

  attr_reader :send_notification_badge

  def remove_product_group_and_send_notification
    if product_group.removable_by?(current_user)
      product_group.remove!
      AllArgumentsPerUser.send_to_team(current_user.team)
    end

    true
  end
end

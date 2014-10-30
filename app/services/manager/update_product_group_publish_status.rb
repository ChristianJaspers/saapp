class Manager::UpdateProductGroupPublishStatus < BusinessProcess::Base
  extend BusinessProcess::Transactional
  transaction_for ProductGroup

  needs :product_group
  needs :params
  needs :current_user

  def call
    update_product_group_publish_status and
        send_push_notification_to_team
  end

  private

  def update_product_group_publish_status
    product_group.archive = attributes.archive
    product_group.archived_at_changed? ? product_group.save : true
  end

  def attributes
    @attributes ||= Dish(params.fetch(:product_group))
  end

  def send_push_notification_to_team
    AllArgumentsPerUser.send_to_team(current_user.team)
    true
  end
end

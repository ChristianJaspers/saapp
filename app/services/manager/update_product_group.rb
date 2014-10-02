class Manager::UpdateProductGroup < BusinessProcess::Base
  extend BusinessProcess::Transactional
  transaction_for ProductGroup

  needs :product_group
  needs :params
  needs :current_user

  def call
    update_product_group_name and
        create_new_arguments and
        destroy_old_arguments and
        update_existing_arguments and
        send_push_notification_to_team
  end

  private

  def update_product_group_name
    product_group.name = attributes.name
    product_group.name_changed? ? product_group.save : true
  end

  def create_new_arguments
    attributes_of_arguments_to_create.all? do |argument_to_create|
      product_group.arguments.new(feature: argument_to_create.feature,
                                  benefit: argument_to_create.benefit,
                                  owner_id: current_user.id).save


    end
  end

  def destroy_old_arguments
    arguments_to_destroy.all? do |argument|
      argument.destroy
    end
  end

  def update_existing_arguments
    arguments_to_update.all? do |argument|
      _attributes = attributes_of_arguments_to_update.find { |attrs| attrs.id == argument.id }

      argument.feature = _attributes.feature
      argument.benefit = _attributes.benefit

      argument.save.tap do
        argument.clear_rating! if argument.clear_rating?
      end
    end
  end

  def arguments_to_update
    product_group.arguments.where(id: attributes_of_arguments_to_update.map(&:id))
  end

  def arguments_to_destroy
    product_group.arguments.where(id: attributes.arguments_to_remove_ids)
  end

  def attributes_of_arguments_to_create
    arguments.select { |argument| argument.id.nil? }
  end

  def attributes_of_arguments_to_update
    arguments.select { |argument| argument.id.present? }
  end

  def arguments
    attributes.arguments || []
  end

  def attributes
    @attributes ||= Dish(params.fetch(:product_group))
  end

  def send_push_notification_to_team
    AllArgumentsPerUser.send_to_team(current_user.team)
    true
  end
end

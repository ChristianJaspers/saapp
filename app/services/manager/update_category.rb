class Manager::UpdateCategory < BusinessProcess::Base
  needs :category
  needs :params
  needs :current_user

  def call
    Category.transaction do
      (update_category_name and
          create_new_arguments and
          destroy_old_arguments and
          update_existing_arguments) or raise ActiveRecord::Rollback
    end
  end

  private

  def update_category_name
    category.name = attributes.name
    category.name_changed? ? category.save : true
  end

  def create_new_arguments
    attributes_of_arguments_to_create.all? do |argument_to_create|
      if (feature = category.features.create(description: argument_to_create.description, owner_id: current_user.id))
        feature.create_benefit(description: argument_to_create.benefit_description)
      end
    end
  end

  def destroy_old_arguments
    true #FIXME To be implemented
  end

  def update_existing_arguments
    features_to_update.all? do |feature|
      _attributes = attributes_of_arguments_to_update.find{|attrs| attrs.id == feature.id}
      benefit = feature.benefit

      feature.description = _attributes.description
      benefit.description = _attributes.benefit_description

      feature.save and benefit.save
    end
  end

  def features_to_update
    category.features.includes(:benefit).where(id: attributes_of_arguments_to_update.map(&:id))
  end

  def attributes_of_arguments_to_create
    attributes.arguments.select { |argument| argument.id.nil? }
  end

  def attributes_of_arguments_to_update
    attributes.arguments.select { |argument| argument.id.present? }
  end

  def attributes
    @attributes ||= Dish(params.fetch(:category))
  end
end

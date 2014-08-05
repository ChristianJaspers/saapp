class Api::ArgumentSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :product_group_id,
             :rating,
             :my_rating,
             :feature,
             :benefit,
             :created_at,
             :updated_at

  def user_id
    object.owner_id
  end

  def rating
    object.rating.to_i
  end

  # PERF n+1
  def my_rating
    current_user.ratings.find_by(argument_id: object.id).try(:to_i) || 0
  end

  def created_at
    object.created_at.try :iso8601
  end

  def updated_at
    object.updated_at.try :iso8601
  end
end

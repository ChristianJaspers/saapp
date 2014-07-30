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
    current_user.id
  end

  def rating
    object.rating.to_i
  end

  def my_rating
    0
  end

  def created_at
    object.created_at.iso8601
  end

  def updated_at
    object.updated_at.iso8601
  end
end

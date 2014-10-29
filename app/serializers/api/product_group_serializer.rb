class Api::ProductGroupSerializer < ActiveModel::Serializer
  COLORS = %w(
    #78c5d5
    #459ba8
    #79c267
    #c5d747
    #f5d63d
    #f18c32
    #e868a1
    #bf63a6
  )

  attributes :id,
             :name,
             :position,
             :color_hex

  def color_hex
    COLORS.rotate(position - 1).first
  end
end

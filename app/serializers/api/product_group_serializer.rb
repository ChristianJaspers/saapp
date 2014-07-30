class Api::ProductGroupSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :position,
             :color_hex

  def initialize(object, options = {})
    super
    @color_iterator = options[:color_iterator]
    @position = options[:position]
  end

  def position
    @position
  end

  def color_hex
    @color_iterator.next
  end
end

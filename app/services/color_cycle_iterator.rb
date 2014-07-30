class ColorCycleIterator
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

  def initialize(list = COLORS)
    @list = Array.wrap(list)
    @index = -1
    raise ArgumentError, 'List has to contain at least one element' if list.empty?
  end

  def current
    if index == -1
      nil
     else
      @list[index]
    end
  end

  def next
    @index = if (index + 1) < list.size
      index + 1
    else
      0
    end
    current
  end

  private

  attr_reader :index, :list
end

# check if the coords are inside of the map ( in bounds )

module Mine
  class InBound
    attr_accessor :max_x, :max_y

    def initialize(max_x, max_y)
      @max_x = max_x
      @max_y = max_y
    end

    def execute(x, y)
      (0 <= x && x <= max_x) && (0 <= y && y <= max_y)
    end

    def true?(x, y)
      execute(x, y)
    end

  end

end
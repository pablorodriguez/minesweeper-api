# frozen_string_literal: true

# check if the coords are inside of the map ( in bounds )

module Mine
  class InBound
    attr_accessor :max_x, :max_y

    def initialize(max_x, max_y)
      @max_x = max_x
      @max_y = max_y
    end

    def execute(coord_x, coord_y)
      (coord_x >= 0 && coord_x <= max_x) && (coord_y >= 0 && coord_y <= max_y)
    end

    def true?(coord_x, coord_y)
      execute(coord_x, coord_y)
    end
  end
end

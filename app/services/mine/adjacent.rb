# frozen_string_literal: true

module Mine
  class Adjacent
    ADJACENT_CONST = [
      [1, 0],
      [1, -1],
      [0, -1],
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, 1],
      [1, 1]
    ].freeze

    def initialize(max_x, max_y)
      @in_bound = Mine::InBound.new(max_x, max_y)
    end

    def execute(coord_x, coord_y)
      get_adjacents(coord_x, coord_y)
    end

    def get_adjacents(coord_x, coord_y)
      adjacent = []
      ADJACENT_CONST.each do |const|
        n_x = coord_x + const[0]
        n_y = coord_y + const[1]
        adjacent << [n_x, n_y] if @in_bound.true?(n_x, n_y)
      end
      adjacent
    end
  end
end

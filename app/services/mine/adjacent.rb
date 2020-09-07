module Mine
  class Adjacent

    ADJACENT_CONST = [
      [1,0],
      [1,-1],
      [0,-1],
      [-1,-1],
      [-1,0],
      [-1,1],
      [0,1],
      [1,1]
    ]

    def initialize(max_x, max_y)
      @in_bound = Mine::InBound.new(max_x, max_y)
    end

    def execute(x,y)
      get_adjacents(x, y)
    end

    def get_adjacents(x, y)
      adjacent = []
      ADJACENT_CONST.each do |const|
        n_x = x+const[0]
        n_y = y+const[1]
        adjacent << [n_x, n_y] if @in_bound.true?(n_x, n_y)
      end
      adjacent
    end

  end
end
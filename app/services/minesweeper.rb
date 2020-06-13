class Minesweeper

  ADJACENT_CONST = [
    [1,0],
    [1,1],
    [0,1],
    [-1,1],
    [-1,0],
    [-1,-1],
    [0,-1],
    [1,-1]
  ]
  def initialize(map = [])
    @map = map
    @max_x = @map[0].size
    @max_y = @map.size
  end

  def click(x, y)
    return true
  end

  def get(x, y)
    @map[x][y]
  end

  def have_mine?(x, y)
    get(x,y) == 'x'
  end

  def is_clear?(x, y)
    !have_mine?(x, y)
  end

  def clear(x, y)
    @map[x,y] = ''
  end

  def get_adjacents(x, y)
    adjacent = []
    ADJACENT_CONST.each do |const|
      n_x = x+const[0]
      n_y = y+const[1]
      adjacent << [n_x, n_y] if is_in_bounds?(n_x, n_y)
    end
    adjacent
  end

  def is_in_bounds?(x, y)
    (0 <= x && x <= @max_x) && (0 <= y && y<= @max_y)
  end


end
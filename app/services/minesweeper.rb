class Minesweeper

  attr_reader :status

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

  def initialize(map = [], print_on_click= false)
    @visited = {}
    @map = map
    @max_x = @map[0].size - 1
    @max_y = @map.size - 1
    @status = "playing"
    @print_on_click = print_on_click
  end

  def click(x, y)
    if @print_on_click
      puts "click on #{x}, #{y}"
      print
    end

    if have_mine?(x,y)
      @status = "loser"
    else
      clear(x,y)
    end
    @status = "winner" if winner?
    if @print_on_click
      print
    end
  end

  def winner?
    @map.flatten.uniq.include?("0") == false
  end

  def get(x, y)
    @map[y][x]
  end

  def have_mine?(x, y)
    get(x,y) == 'X'
  end

  def set_value_at(x,y,value)
    @map[y][x] = value
  end

  def is_clear?(x, y)
    get(x, y) == ' '
  end

  def clear(x, y)
    cell_key = "#{x}##{y}"
    return if @visited[cell_key]
    set_value_at(x,y,' ')
    @visited[cell_key] = true
    adjacents = get_adjacents(x, y)
    return unless all_emptys?(adjacents)
    adjacents.each{|cell| clear(cell[0], cell[1])}
  end

  def are_adjacents_emptys?(x, y)
    all_emptys?(get_adjacents(x, y))
  end

  def all_emptys?(cells)
    cells.find{|cell| have_mine?(cell[0], cell[1])} == nil
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
    (0 <= x && x <= @max_x) && (0 <= y && y <= @max_y)
  end

  def print
    table = TTY::Table.new(@map)
    puts table.render(:unicode)
    puts @status
  end


end
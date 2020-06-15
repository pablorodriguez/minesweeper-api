class Minesweeper < ApplicationRecord
  belongs_to :user
  serialize :visited, Hash
  serialize :map, Array
  validates :map, presence: true
  validates :max_y, :max_x, :amount_of_mines, numericality: { only_integer: true , greater_than: 0  }

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

  after_initialize do |game|
    game.set_default_values
  end

  def set_default_values
    if map.empty? && max_x && max_y
      init_map
      visited ||= {}
      max_x = map[0].size - 1
      max_y = map.size - 1
    end
    status = "playing"
  end

  def set_map(new_map)
    self.map = new_map
    self.visited = {}
    self.max_x = self.map[0].size - 1
    self.max_y = self.map.size - 1
    self.status = "playing"
    self.amount_of_mines= self.map.flatten.select{|c| c == 'X'}.count
  end

  def init_map
    new_map = []
    max_y.times.each{ |t| new_map << Array.new(max_x,'') }
    mines = {}

    while number_of_mines > 0
      x = rand(max_x).to_i
      y = rand(max_y).to_i
      key = "#{x}##{y}"
      unless mines[key]
        new_map[y][x] = 'X'
        mines[key] = true
        number -= 1
      end
    end

    map = new_map
  end

  def click(x, y)
    if have_mine?(x,y)
      self.status = "loser"
    else
      clear(x,y)
      self.status = "winner" if winner?
    end
  end

  def winner?
    map.flatten.find{|d| d == "0"} != nil
  end

  def get(x, y)
    map[y][x]
  end

  def have_mine?(x, y)
    get(x,y) == 'X'
  end

  def set_value_at(x,y,value)
    map[y][x] = value
  end

  def is_clear?(x, y)
    get(x, y) == ' '
  end

  def clear(x, y)
    cell_key = "#{x}##{y}"
    return if visited[cell_key]
    set_value_at(x,y,' ')
    visited[cell_key] = true
    adjacents = get_adjacents(x, y)
    mines = get_mines(adjacents)
    if mines.size > 0
      set_value_at(x, y, mines.size.to_s)
      return
    end
    adjacents.each{|cell| clear(cell[0], cell[1])}
  end

  def are_adjacents_emptys?(x, y)
    all_emptys?(get_adjacents(x, y))
  end

  def all_emptys?(cells)
    cells.find{|cell| have_mine?(cell[0], cell[1])} == nil
  end

  def get_mines(cells)
    cells.select{|cell| have_mine?(cell[0], cell[1])}
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
    (0 <= x && x <= max_x) && (0 <= y && y <= max_y)
  end

  def print
    table = TTY::Table.new(map)
    puts table.render(:unicode)
    puts status
  end

end

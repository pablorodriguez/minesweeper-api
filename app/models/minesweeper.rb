class Minesweeper < ApplicationRecord
  belongs_to :user
  serialize :visited, Hash
  serialize :map, Array
  validates :map, :name, presence: true
  validates :max_y, :max_x, :amount_of_mines, numericality: { only_integer: true , greater_than: 0  }
  validates :name, uniqueness: { scope: :user_id, message: "duplicate within the same user" }
  before_save :set_time_spend, if: :will_save_change_to_status?

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
    game.amount_of_mines ||= 0
    game.time_spend ||= 0
    game.status ||= "playing"
    game.start_play_at ||= Time.now
    game.init_map if (game.map.empty? && game.max_x && game.max_y && game.amount_of_mines > 0)
  end

  def set_time_spend
    if status_in_database && status_in_database == 'playing'
      self.time_spend += playing_time
      self.start_play_at = Time.now
    end
  end

  def time
    status == "playing" ? playing_time : time_spend
  end

  def playing_time
    self.start_play_at ? (((Time.now - self.start_play_at) / 60) + time_spend).round(2) : 0
  end

  def set_map(new_map)
    self.map = new_map
    self.visited = {}
    self.max_x = self.map[0].size - 1
    self.max_y = self.map.size - 1
    self.status = "playing"
    self.amount_of_mines= self.map.flatten.select{|c| c == 'X'}.count
  end

  # Initialize the map mines on random coords
  def init_map
    new_map = []
    max_y.times.each{ |t| new_map << Array.new(max_x,'#') }
    mines = {}
    amount = amount_of_mines
    while amount > 0
      x = rand(max_x).to_i
      y = rand(max_y).to_i
      key = "#{x}##{y}"
      unless mines[key]
        new_map[y][x] = 'X'
        mines[key] = true
        amount -= 1
      end
    end

    self.map = new_map
    self.visited = {}
    self.max_x = map[0].size - 1
    self.max_y = map.size - 1
  end

  def valid_coords_and_status?(x,y)
    unless is_in_bounds?(x,y)
      self.errors.add(:base, "coordinates out of bounds")
    end
    self.errors.add(:status, "the games is over, you lose") if status == "loser"
    self.errors.add(:status, "the games is over, you won") if status == "winner"

    self.errors.empty?
  end

  def restart
    init_map
    self.time_spend = 0
    self.save
  end

  def stop
    self.status = "stop"
    self.save
  end

  def play
    self.status = "playing"
    self.save
  end

  def click(x, y)
    return unless valid_coords_and_status?(x,y)
    if have_mine?(x,y)
      self.status = "loser"
    else
      clear(x,y)
      if winner?
        self.status = "winner"
      end
    end
    self.save
  end

  def flag(x, y)
    return unless valid_coords_and_status?(x,y)
    if have_flag?(x,y)
      current_value = get(x,y)
      new_value = current_value.split("/")[1]
      set_value_at(x,y,new_value)
    elsif have_mine?(x,y)
      set_value_at(x,y,'F/X')
    else
      set_value_at(x,y,'F/#')
    end
    self.save
  end

  # Check there is not # on the map, that means you win
  def winner?
    map.flatten.find{|d| d == "#"} == nil
  end

  def get(x, y)
    map[y][x]
  end

  def have_mine?(x, y)
    get(x,y).include?('X')
  end

  def have_flag?(x,y)
    get(x,y)[0] == 'F'
  end

  def set_value_at(x,y,value)
    map[y][x] = value
  end

  def is_clear?(x, y)
    get(x, y) == ' '
  end

  #
  # Retrun if the cell x,y was visited
  # Clear the value for thecell
  # Get Adjacents for the cell x,y
  # If all adjacent are clear call Clear on each one
  # If there are some mines set the amount of mine
  #
  def clear(x, y)
    cell_key = "#{x}##{y}"
    return if visited[cell_key]
    set_value_at(x,y,' ')
    visited[cell_key] = true
    adjacents = get_adjacents(x, y)
    mines = get_mines(adjacents)
    if mines.size > 0
      set_value_at(x, y, mines.size.to_s)
    else
      adjacents.each{|cell| clear(cell[0], cell[1])}
    end
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

  # check if the coords are inside of the map ( in bounds )
  def is_in_bounds?(x, y)
    (0 <= x && x <= max_x) && (0 <= y && y <= max_y)
  end

  #
  # Print the map on the console
  #
  def print
    table = TTY::Table.new(map)
    puts table.render(:unicode)
    puts status
  end

  #
  # Use view map to show map info to the user, this hide where mines are
  #
  def view_map
    n_map = []
    map.each do |row|
      n_map << row.map do |e|
        case e[0]
        when 'F'
          'F'
        when 'X'
          '#'
        else
          e
        end
      end
    end
    n_map
  end

end

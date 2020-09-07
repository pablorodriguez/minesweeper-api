# frozen_string_literal: true

class Minesweeper < ApplicationRecord
  belongs_to :user
  serialize :visited, Hash
  serialize :map, Array
  validates :map, :name, presence: true
  validates :max_y, :max_x, :amount_of_mines, numericality: { only_integer: true, greater_than: 0 }
  validates :name, uniqueness: { scope: :user_id, message: 'duplicate within the same user' }
  before_save :set_time_spend, if: :will_save_change_to_status?

  after_initialize do |game|
    game.amount_of_mines ||= 0
    game.time_spend ||= 0
    game.status ||= 'playing'
    game.start_play_at ||= Time.now
    game.init_map if game.map.empty? && game.max_x && game.max_y && game.amount_of_mines.positive?
  end

  def set_time_spend
    return unless playing?

    self.time_spend += playing_time
    self.start_play_at = Time.now
  end

  def playing?
    status_in_database && status_in_database == 'playing'
  end

  def time
    status == 'playing' ? playing_time : time_spend
  end

  def playing_time
    start_play_at ? (((Time.now - start_play_at) / 60) + time_spend).round(2) : 0
  end

  # Initialize the map mines on random coords
  def init_map
    new_map = []
    max_y.times.each { |_t| new_map << Array.new(max_x, '#') }
    mines = {}
    amount = amount_of_mines
    while amount.positive?
      x = rand(max_x).to_i
      y = rand(max_y).to_i
      key = "#{x}##{y}"
      next if mines[key]

      new_map[y][x] = 'X'
      mines[key] = true
      amount -= 1
    end

    self.map = new_map
    self.visited = {}
    self.max_x = map[0].size - 1
    self.max_y = map.size - 1
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

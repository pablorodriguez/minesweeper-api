class GameSpecsHelpers
  class << self
    def get_coords(game, value)
      y = nil
      x = nil
      game.map.each_with_index do |values, index|
        y = index
        x = values.index(value)
        break if x
      end
      return x, y
    end

  end

end
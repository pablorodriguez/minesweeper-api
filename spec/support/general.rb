# frozen_string_literal: true

class GameSpecsHelpers
  class << self
    def get_coords(map, value)
      y = nil
      x = nil
      map.each_with_index do |values, index|
        y = index
        x = values.index(value)
        break if x
      end
      [x, y]
    end
  end
end

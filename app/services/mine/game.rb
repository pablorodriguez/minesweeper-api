# frozen_string_literal: true

module Mine
  class Game
    attr_accessor :model

    def initialize(model)
      @model = model
      set_dependencies
    end

    def set_dependencies
      @in_bound = Mine::InBound.new(model.max_x, model.max_y)
      @adjacent = Mine::Adjacent.new(model.max_x, model.max_y)
    end

    def execute(params)
      result = if %w[click flag stop play].include?(params[:perform])
                 if params[:x].present? && params[:y].present?
                   send(params[:perform], params[:x].to_i, params[:y].to_i)
                 else
                   send(params[:perform])
                 end
               end
      result
    end

    def set_map(new_map)
      model.map = new_map
      model.visited = {}
      model.max_x = model.map[0].size - 1
      model.max_y = model.map.size - 1
      model.status = 'playing'
      model.amount_of_mines = model.map.flatten.select { |c| c == 'X' }.count
      model.save
      set_dependencies
    end

    def restart
      model.init_map
      model.time_spend = 0
      model.save
    end

    def time_spend
      model.time_spend
    end

    def in_bounds?(coord_x, coord_y)
      @in_bound.true?(coord_x, coord_y)
    end

    def status
      model.status
    end

    def visited
      model.visited
    end

    def stop
      model.status = 'stop'
      model.save
    end

    def play
      model.status = 'playing'
      model.save
    end

    def click(coord_x, coord_y)
      return unless valid_coords_and_status?(coord_x, coord_y)

      if mine?(coord_x, coord_y)
        model.status = 'loser'
      else
        clear(coord_x, coord_y)
        model.status = 'winner' if winner?
      end
      model.save
    end

    #
    # Retrun if the cell x,y was visited
    # Clear the value for the cell
    # Get Adjacents for the cell x,y
    # If all adjacent are clear call Clear on each one
    # If there are some mines set the amount of mine
    #
    def clear(coord_x, coord_y)
      cell_key = "#{coord_x}##{coord_y}"
      return if model.visited[cell_key]

      set_value_at(coord_x, coord_y, ' ')
      model.visited[cell_key] = true
      adjacents = get_adjacents(coord_x, coord_y)
      mines = get_mines(adjacents)
      if mines.size.positive?
        set_value_at(coord_x, coord_y, mines.size.to_s)
      else
        adjacents.each { |cell| clear(cell[0], cell[1]) }
      end
    end

    def get_adjacents(coord_x, coord_y)
      @adjacent.execute(coord_x, coord_y)
    end

    def flag(coord_x, coord_y)
      return unless valid_coords_and_status?(coord_x, coord_y)

      if flag?(coord_x, coord_y)
        current_value = get(coord_x, coord_y)
        new_value = current_value.split('/')[1]
        set_value_at(coord_x, coord_y, new_value)
      elsif mine?(coord_x, coord_y)
        set_value_at(coord_x, coord_y, 'F/X')
      else
        set_value_at(coord_x, coord_y, 'F/#')
      end
      model.save
    end

    def valid_coords_and_status?(coord_x, coord_y)
      model.errors.add(:base, 'coordinates out of bounds') unless @in_bound.true?(coord_x, coord_y)
      model.errors.add(:status, 'the games is over, you lose') if status == 'loser'
      model.errors.add(:status, 'the games is over, you won') if status == 'winner'
      model.errors.empty?
    end

    def time
      model.time
    end

    # Check there is not # on the map, that means you win
    def winner?
      model.map.flatten.find { |d| d == '#' }.nil?
    end

    def get(coord_x, coord_y)
      model.map[coord_y][coord_x]
    end

    def mine?(coord_x, coord_y)
      get(coord_x, coord_y).include?('X')
    end

    def flag?(coord_x, coord_y)
      get(coord_x, coord_y)[0] == 'F'
    end

    def set_value_at(coord_x, coord_y, value)
      model.map[coord_y][coord_x] = value
    end

    def clear?(coord_x, coord_y)
      get(coord_x, coord_y) == ' '
    end

    def get_mines(cells)
      cells.select { |cell| mine?(cell[0], cell[1]) }
    end

    def are_adjacents_emptys?(coord_x, coord_y)
      all_emptys?(get_adjacents(coord_x, coord_y))
    end

    def all_emptys?(cells)
      cells.find { |cell| mine?(cell[0], cell[1]) }.nil?
    end
  end
end

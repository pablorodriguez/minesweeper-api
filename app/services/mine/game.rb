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
      result = if (['click', 'flag','stop','play'].include?(params[:perform]))
        if params[:x].present? && params[:y].present?
          self.send(params[:perform],params[:x].to_i, params[:y].to_i)
        else
          self.send(params[:perform])
        end
      end
      result
    end

    def set_map(new_map)
      model.map = new_map
      model.visited = {}
      model.max_x = model.map[0].size - 1
      model.max_y = model.map.size - 1
      model.status = "playing"
      model.amount_of_mines= model.map.flatten.select{|c| c == 'X'}.count
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

    def is_in_bounds?(x, y)
      @in_bound.true?(x, y)
    end

    def status
      model.status
    end

    def visited
      model.visited
    end

    def stop
      model.status = "stop"
      model.save
    end

    def play
      model.status = "playing"
      model.save
    end

    def click(x, y)
      return unless valid_coords_and_status?(x,y)
      if have_mine?(x,y)
        model.status = "loser"
      else
        clear(x,y)
        if winner?
          model.status = "winner"
        end
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
    def clear(x, y)
      cell_key = "#{x}##{y}"
      return if model.visited[cell_key]
      set_value_at(x,y,' ')
      model.visited[cell_key] = true
      adjacents = get_adjacents(x, y)
      mines = get_mines(adjacents)
      if mines.size > 0
        set_value_at(x, y, mines.size.to_s)
      else
        adjacents.each{|cell| clear(cell[0], cell[1])}
      end
    end

    def get_adjacents(x, y)
      @adjacent.execute(x, y)
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
      model.save
    end

    def valid_coords_and_status?(x,y)
      unless @in_bound.true?(x,y)
        model.errors.add(:base, "coordinates out of bounds")
      end
      model.errors.add(:status, "the games is over, you lose") if status == "loser"
      model.errors.add(:status, "the games is over, you won") if status == "winner"

      model.errors.empty?
    end

    def time
      model.time
    end


    # Check there is not # on the map, that means you win
    def winner?
      model.map.flatten.find{|d| d == "#"} == nil
    end

    def get(x, y)
      model.map[y][x]
    end

    def have_mine?(x, y)
      get(x,y).include?('X')
    end

    def have_flag?(x,y)
      get(x,y)[0] == 'F'
    end

    def set_value_at(x,y,value)
      model.map[y][x] = value
    end

    def is_clear?(x, y)
      get(x, y) == ' '
    end

    def get_mines(cells)
      cells.select{|cell| have_mine?(cell[0], cell[1])}
    end

    def are_adjacents_emptys?(x, y)
      all_emptys?(get_adjacents(x, y))
    end

    def all_emptys?(cells)
      cells.find{|cell| have_mine?(cell[0], cell[1])} == nil
    end


  end
end
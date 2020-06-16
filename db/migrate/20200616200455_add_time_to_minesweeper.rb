class AddTimeToMinesweeper < ActiveRecord::Migration[5.2]
  def change
    add_column :minesweepers, :time_spend, :float
  end
end

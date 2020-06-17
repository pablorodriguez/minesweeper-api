class AddStartPlayTimeToMinesweeper < ActiveRecord::Migration[5.2]
  def change
    add_column :minesweepers, :start_play_at, :datetime
  end
end

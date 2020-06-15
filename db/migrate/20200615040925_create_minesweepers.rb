class CreateMinesweepers < ActiveRecord::Migration[5.2]
  def change
    create_table :minesweepers do |t|
      t.string :name
      t.string :status
      t.references :user, foreign_key: true
      t.text :map
      t.text :visited
      t.integer :max_x
      t.integer :max_y
      t.integer :amount_of_mines

      t.timestamps
    end
  end
end

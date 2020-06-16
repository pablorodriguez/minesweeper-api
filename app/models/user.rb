class User < ApplicationRecord

  has_many :minesweeper

  validates :name, presence: true
end

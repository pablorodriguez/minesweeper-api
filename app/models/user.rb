# frozen_string_literal: true

class User < ApplicationRecord
  has_many :minesweeper

  validates :name, presence: true
end

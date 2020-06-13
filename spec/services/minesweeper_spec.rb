require 'rails_helper'

RSpec.describe 'Minesweeper' do
  let(:map) {
    [
      [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ',' ',' ','x'],
    ]
  }
  let(:game) { Minesweeper.new(map) }

  context 'validate content' do
    it "2,2 is clear" do
      expect(game.is_clear?(2,2)).to be_truthy
    end

    it "9,9 have mine" do
      expect(game.have_mine?(9,9)).to be_truthy
    end
  end

  context 'valiate boundaries' do

    context 'map 10 x 10' do

      it '0,0 is in' do
        expect(game.is_in_bounds?(0,0)).to be_truthy
      end

      it '9,9 is in' do
        expect(game.is_in_bounds?(9,9)).to be_truthy
      end

      it '9,11 is off' do
        expect(game.is_in_bounds?(9,11)).to be_falsey
      end

      it '-1,0 is ff' do
        expect(game.is_in_bounds?(-1,0)).to be_falsey
      end

    end
  end

  context 'validate adjacents' do
    it '[0,0] => [ [1,0], [1,1], [0,1] ]' do
      adjacents = game.get_adjacents(0,0)
      expect(adjacents.size).to eq(3)
      expect(adjacents).to eq( [ [1,0], [1,1], [0,1] ])
    end

    it '[1,1] => [ [2,1],[2,2],[1,2],[0,2],[0,1],[0,0],[1,0],[2,0] ]' do
      adjacents = game.get_adjacents(1,1)
      expect(adjacents.size).to eq(8)
      expect(adjacents).to eq( [ [2,1],[2,2],[1,2],[0,2],[0,1],[0,0],[1,0],[2,0] ] )
    end

  end

end
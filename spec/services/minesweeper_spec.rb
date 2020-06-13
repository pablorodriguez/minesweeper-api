require 'rails_helper'

RSpec.describe 'Minesweeper' do
  let(:game) { Minesweeper.new(map) }
  let(:map) {
    [
      ['0','0','0','0','0','0','0','0','0','0'],
      ['0','0','0','0','0','0','0','0','0','0'],
      ['0','0','0','0','0','0','0','0','0','0'],
      ['0','0','0','0','0','0','0','0','0','0'],
      ['0','0','0','0','0','0','0','0','0','0'],
      ['XX','0','0','0','0','0','0','0','0','X'],
      ['0','0','0','0','0','0','0','0','0','0'],
      ['0','0','0','0','0','0','0','0','0','0'],
      ['0','0','0','0','0','0','0','0','0','0'],
      ['0','0','0','X','0','X','0','0','0','X']
    ]
  }

  context 'validate content' do
    it "2,2 is clear" do
      expect(game.is_clear?(2,2)).to be_truthy
    end

    it "9,9 have mine" do
      expect(game.have_mine?(9,9)).to be_truthy
    end

    it "3,0 have mine" do
      expect(game.have_mine?(3,9)).to be_truthy
    end

    it "clear 9,9" do
      game.clear(9,9)
      expect(game.have_mine?(9,9)).to be_falsey
    end

  end
  context 'validate adjacents content' do

    it "[1,1] adjacent are clear" do
      expect(game.are_adjacents_clear?(1,1)).to be_truthy
    end

    it "[8,8] adjacent are not clear" do
      expect(game.are_adjacents_clear?(8,8)).to be_falsey
    end

  end
  context 'valiate boundaries' do
    context 'map 10 x 10' do

      it '0,0 is in' do
        expect(game.is_in_bounds?(0,0)).to be_truthy
      end
      it '0,9 is in' do
        expect(game.is_in_bounds?(0,9)).to be_truthy
      end
      it '9,9 is in' do
        expect(game.is_in_bounds?(9,9)).to be_truthy
      end
      it '9,0 is in' do
        expect(game.is_in_bounds?(9,0)).to be_truthy
      end

      it '10,10 is off' do
        expect(game.is_in_bounds?(10,10)).to be_falsey
      end

      it '10,9 is off' do
        expect(game.is_in_bounds?(10,9)).to be_falsey
      end


      it '9,11 is off' do
        expect(game.is_in_bounds?(9,11)).to be_falsey
      end

      it '-1,0 is ff' do
        expect(game.is_in_bounds?(-1,0)).to be_falsey
      end

      it '-1,-1 is ff' do
        expect(game.is_in_bounds?(-1,-1)).to be_falsey
      end

    end
  end
  context 'validate adjacents on corners' do
    it 'top/left [0,0] => [ [1,0], [0,1], [1,1] ]' do
      adjacents = game.get_adjacents(0,0)
      expect(adjacents.size).to eq(3)
      expect(adjacents).to eq( [ [1,0], [0,1], [1,1] ])
    end

    it 'top/right [9,0] => [ [8,0],[8,1],[9,1] ]' do
      adjacents = game.get_adjacents(9,0)
      expect(adjacents.size).to eq(3)
      expect(adjacents).to eq( [ [8,0],[8,1],[9,1] ] )
    end

    it 'bottom/right [9,9] => [ [9,8],[8,8],[8,9] ]' do
      adjacents = game.get_adjacents(9,9)
      expect(adjacents.size).to eq(3)
      expect(adjacents).to eq( [ [9,8],[8,8],[8,9] ] )
    end

    it 'bottom/left [0,9] => [ [1,9],[1,8],[0,8] ]' do
      adjacents = game.get_adjacents(0,9)
      expect(adjacents.size).to eq(3)
      expect(adjacents).to eq( [ [1,9],[1,8],[0,8] ] )
    end
  end
  context 'validate inner adjacents' do
    it '[1,1] => [ [2,1],[2,0],[1,0],[0,0],[0,1],[0,2],[1,2],[2,2] ]' do
      adjacents = game.get_adjacents(1,1)
      expect(adjacents.size).to eq(8)
      expect(adjacents).to eq( [ [2,1],[2,0],[1,0],[0,0],[0,1],[0,2],[1,2],[2,2] ] )
    end
  end

  context 'validate border adjacents' do
    it 'top border [4,0] => [ [5,0],[3,0],[3,1],[4,1],[5,1] ]' do
      adjacents = game.get_adjacents(4,0)
      expect(adjacents.size).to eq(5)
      expect(adjacents).to eq( [ [5,0],[3,0],[3,1],[4,1],[5,1] ] )
    end

    it 'left border [9,5] => [ [9,4],[8,4],[8,5],[8,6],[9,6] ]' do
      adjacents = game.get_adjacents(9,5)
      expect(adjacents.size).to eq(5)
      expect(adjacents).to eq( [ [9,4],[8,4],[8,5],[8,6],[9,6] ] )
    end

    it 'bottom border [5,9] => [ [6,9],[6,8],[5,8],[4,8],[4,9] ]' do
      adjacents = game.get_adjacents(5,9)
      expect(adjacents.size).to eq(5)
      expect(adjacents).to eq( [ [6,9],[6,8],[5,8],[4,8],[4,9] ] )
    end

    it 'right border [0,5] => [ [1,5],[1,4],[0,4],[0,6],[1,6] ]' do
      adjacents = game.get_adjacents(0,5)
      expect(adjacents.size).to eq(5)
      expect(adjacents).to eq( [ [1,5],[1,4],[0,4],[0,6],[1,6] ] )
    end

  end

end
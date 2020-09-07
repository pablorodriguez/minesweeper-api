require 'rails_helper'

RSpec.describe Minesweeper, type: :model do
  let(:game) do
    game = Minesweeper.new(name: 'TestGame', user_id: user.id)
    game.set_map(map)
    game.save
    game
  end

  let(:user) { User.create(name: "pablomdz") }

  context 'validations' do
    context "with max_x, max_y, amount of mines, name and user" do
      subject { Minesweeper.new({max_x:10, max_y:10, amount_of_mines:10, user_id: user.id, name: "Test Game"}) }

      it { is_expected.to be_valid }
      it { should  belong_to(:user) }
    end

    context "without amount fo mines" do
      subject { Minesweeper.new({max_x:10, max_y:10,user_id: user.id, name: "Test Game"}) }
      it { is_expected.not_to be_valid }
      it { expect(subject.amount_of_mines).not_to be > 0 }
      it { should validate_presence_of(:amount_of_mines).with_message("is not a number") }
    end

    context "validate unique name by user" do
      before do
        game_a = Minesweeper.new({max_x:10, max_y:10,amount_of_mines: 10, user_id: user.id, name: "Game A"})
      end

      subject { Minesweeper.new({max_x:10, max_y:10, amount_of_mines:10, user_id: user.id, name: "Game A"}) }
      it { should validate_uniqueness_of(:name).scoped_to(:user_id).with_message('duplicate within the same user') }
    end

    context "without max_x" do
      let(:game_a) { Minesweeper.new({max_x:10, max_y:10,amount_of_mines:10}) }
      it { is_expected.not_to be_valid }
    end

    context "without max_y" do
      let(:game_a) { Minesweeper.new({max_x:10,amount_of_mines:10}) }
      it { is_expected.not_to be_valid }
    end

  end

end

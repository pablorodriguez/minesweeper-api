require 'rails_helper'

RSpec.describe MinesweepersController, type: :controller do

  let(:user) { User.create(name: "pablomdz") }

  let(:parsed_response) { JSON.parse(response.body) }

  it "GET#index returns a OK" do
    get :index
    expect(response).to have_http_status(200)
  end

  describe 'POST#create' do
    let(:params) {{
      name: "Game A",
      user_name: user.name,
      max_x: 15,
      max_y: 15,
      amount_of_mines: 15
    }}

    it 'return SUCCESS' do
      post :create, params: params
      expect(response).to have_http_status(:success)
    end

    it 'return UNPROCESSABLE_ENTITY for amount of mines 0' do
      params["amount_of_mines"] = 0
      post :create, params: params
      expect(response).to have_http_status(:unprocessable_entity)
    end

  end

  describe 'PATCH#click' do
    let(:game) { Minesweeper.create({max_x:10, max_y:10, amount_of_mines:10, user_id: user.id, name: "Test Game"}) }
    it 'click over cell 2,2' do
      patch :click, params: {id: game.id, x:2, y:2 }
      expect(parsed_response['game']).not_to be_nil
      expect(response).to have_http_status(200)
    end

    it 'click over a mine, game over' do
      y = nil
      x = nil
      game.map.each_with_index do |values, index|
        y = index
        x = values.index("X")
        break if x
      end

      patch :click, params: {id: game.id, x:x, y:y }
      game = parsed_response['game']

      expect(response).to have_http_status(200)
      expect(game).not_to be_nil
      expect(game['status']).to eq('loser')

    end
  end
end

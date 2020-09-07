require 'rails_helper'

RSpec.describe MinesweepersController, type: :controller do

  let(:user) { User.create(name: "pablomdz") }
  let(:parsed_response) { JSON.parse(response.body) }
  let(:game) { Minesweeper.create({max_x:10, max_y:10, amount_of_mines:10, user_id: user.id, name: "Test Game"}) }

  let(:params) {{
    name: "Game A",
    max_x: 15,
    max_y: 15,
    user_name: "pablomdz",
    amount_of_mines: 15
  }}
  describe "GET#index" do
    it "returns a OK" do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST#create' do

    it 'return SUCCESS' do
      expect(user.name).to eq("pablomdz")
      post :create, params: params
      expect(parsed_response['game']['user']['id']).to eq(user.id)
      expect(response).to have_http_status(:success)
    end

    it 'return UNPROCESSABLE_ENTITY for amount of mines 0' do
      params.merge!(user_name: user.name,amount_of_mines: 0)
      post :create, params: params
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'create a new user' do
      params[:user_name] = 'hugomdz'
      expect{ post :create, params: params  }.to change{ User.count}.by(1)
    end

    it "create a duplicate game name" do
      params[:name] = game.name
      post :create, params: params
      expect(response).to have_http_status(:unprocessable_entity)
    end

  end

  describe 'PATCH#actions' do

    it 'click over cell 2,2' do
      patch :update, params: {id: game.name, x:2, y:2, perform: 'click' }
      expect(parsed_response['game']).not_to be_nil
      expect(response).to have_http_status(200)
    end

    it 'flag over cell 2,2' do
      id = game.id
      patch :update, params: {id: game.name, x:2, y:2, perform: 'flag' }
      expect(parsed_response['game']).not_to be_nil
      expect(response).to have_http_status(200)
      n_game = Mine::Game.new(Minesweeper.find(id))
      expect(n_game.get(2,2)).to include('F')
    end

    it 'flag over mine' do
      id = game.id
      x,y = GameSpecsHelpers.get_coords(game.map, 'X')
      patch :update, params: {id: game.name, x:x, y:y, perform: 'flag' }
      expect(parsed_response['game']).not_to be_nil
      expect(response).to have_http_status(200)
      n_game = Mine::Game.new(Minesweeper.find(id))
      expect(n_game.get(x,y)).to eq('F/X')
    end

    it 'un flag over mine' do
      id = game.id
      x,y = GameSpecsHelpers.get_coords(game.map,'X')
      patch :update, params: {id: game.name, x:x, y:y, perform: 'flag' }
      expect(parsed_response['game']).not_to be_nil
      expect(response).to have_http_status(200)

      patch :update, params: {id: game.name, x:x, y:y, perform: 'flag' }
      n_game = Mine::Game.new(Minesweeper.find(id))
      expect(n_game.get(x,y)).to eq('X')
    end

    it 'un flag over cell 2,2' do
      id = game.id
      patch :update, params: {id: game.name, x:2, y:2, perform: 'flag' }
      expect(parsed_response['game']).not_to be_nil
      expect(response).to have_http_status(200)
      patch :update, params: {id: game.name, x:2, y:2, perform: 'flag' }
      n_game = Mine::Game.new(Minesweeper.find(id))
      expect(n_game.get(2,2)).not_to include('F')
    end

    it 'update data' do
      patch :update, params: {id: game.name, name: "Game 2" }
      expect(parsed_response['game']).not_to be_nil
      expect(response).to have_http_status(200)
      n_game = Minesweeper.find_by_name("Game 2")
      expect(n_game).not_to be_nil
    end


    it 'click over a mine, game over' do
      x,y = GameSpecsHelpers.get_coords(game.map,'X')
      patch :update, params: {id: game.name, x:x, y:y, perform: 'click' }
      n_game = parsed_response['game']

      expect(response).to have_http_status(200)
      expect(n_game).not_to be_nil
      expect(n_game['status']).to eq('loser')

    end

  end
end

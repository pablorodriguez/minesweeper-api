class MinesweepersController < ApplicationController
  before_action :set_user, only: [:create]
  before_action :set_game, only: [:update, :click]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {error: "Record not found" }, status: 404
  end

  def index
    games = Minesweeper.all
    respond_to do |format|
      format.html
      format.json { render json: { games: games.as_json}, status: :ok }
    end
  end

  def create
    game = Minesweeper.new(game_params.merge(user_id: @user.id))
    if game.save
      render json: { game: game.as_json}, status: :ok
    else
      render json: { errors: game.errors.full_messages, game: game.as_json}, status: :unprocessable_entity
    end
  end

  def update
    if game.update(game_params)
      render json: { game: game.as_json}, status: :ok
    else
      render json: { errors: game.error.full_messages, game: game.as_json}, status: :unprocessable_entity
    end
  end

  def click
    @game.click(params[:x].to_i, params[:y].to_i)
    render json: { game: @game.as_json}, status: :ok
  end

  private

  def set_user
    @user = User.where("name = ?", params[:user_name]).take
    raise ActiveRecord::RecordNotFound unless @user
  end

  def set_game
    @game = Minesweeper.find(params[:id])
  end

  def game_params
    params.permit(:name, :max_x, :max_y, :amount_of_mines)
  end
end

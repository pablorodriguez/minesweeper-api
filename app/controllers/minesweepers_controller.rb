class MinesweepersController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_user, only: [:create]
  before_action :set_game, only: [:update, :click, :show]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {error: "Record not found" }, status: 404
  end

  def show
    render json: { game: @game.as_json(include: :user)}, status: :ok
  end

  def index
    @games = Minesweeper.all
    respond_to do |format|
      format.html
      format.json { render json: { games: @games.as_json(methods: [:view_map, :time], exclude: :map, include: :user)}, status: :ok }
    end
  end

  def create
    game = Minesweeper.new(game_params.merge(user_id: @user.id))
    if game.save
      render json: { game: game.as_json(methods: [:view_map, :time], exclude: :map, include: :user)}, status: :ok
    else
      render json: { errors: game.errors.full_messages, game: game.as_json}, status: :unprocessable_entity
    end
  end

  def update
    result = if (['click', 'flag'].include?(params[:perform]))
      @game.send(params[:perform],params[:x].to_i, params[:y].to_i)
    else
      @game.update(game_params)
    end

    if result
      render json: { game: @game.as_json(methods: [:view_map, :time], exclude: :map, include: :user)}, status: :ok
    else
      render json: { errors: @game.error.full_messages, game: @game.as_json}, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_or_create_by(name: params[:user_name])
  end

  def set_game
    @game = Minesweeper.find_by_name(params[:id])
  end

  def game_params
    params.permit(:name, :max_x, :max_y, :amount_of_mines)
  end
end

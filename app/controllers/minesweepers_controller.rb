class MinesweepersController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_user, only: [:create]
  before_action :set_game, only: [:update, :show]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {error: "Record not found" }, status: 404
  end

  def show
    render json: { game: as_json(@game)}, status: :ok
  end

  def index
    @games =  if params[:user_name]
      Minesweeper.joins(:user).where("users.name like ?", params[:user_name]).order("minesweeper.id desc")
    else
      Minesweeper.all.order("id desc")
    end

    respond_to do |format|
      format.html
      format.json { render json: { games: as_json(@games)}, status: :ok }
    end
  end

  def create
    game = Minesweeper.new(game_params.merge(user_id: @user.id))
    if game.save
      render json: { game: as_json(game) }, status: :ok
    else
      render json: { errors: game.errors.full_messages, game: as_json(game) }, status: :unprocessable_entity
    end
  end

  def as_json(obj)
    obj.as_json(only: [:name, :status, :created_at, :updated_at], methods: [:view_map, :time], include: :user)
  end

  def update
    result = if (['click', 'flag','stop','play'].include?(params[:perform]))
      if params[:x].present? && params[:y].present?
        @game.send(params[:perform],params[:x].to_i, params[:y].to_i)
      else
        @game.send(params[:perform])
      end
    else
      @game.update(game_params)
    end

    if result
      render json: { game: as_json(@game)}, status: :ok
    else
      render json: { errors: @game.errors.full_messages, game: as_json(@game)}, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_or_create_by(name: params[:user_name])
  end

  # Search the game by its name, we use the game name as its id to search
  def set_game
    @game = Minesweeper.find_by_name!(params[:id])
  end

  def game_params
    params.permit(:name, :max_x, :max_y, :amount_of_mines)
  end
end

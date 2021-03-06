class Admin::GamesController < ApplicationController
  def create
    game = Game.create(game_params) do |game|
      game.map = Maps.const_get("COMPETITION_#{Integer(params[:map_number])}")
    end

    redirect_to [:admin, game]
  end

  def show
    @game = Game.find(params[:id])
  end

  def start
    game = Game.find(params[:id])
    gr = GameRunner.new(game.home_player.code, game.guest_player.code, game.map)
    moves = gr.()
    render json: { map: game.map, moves: moves.flatten }
  rescue RuntimeError => e
    render json: { error: e.to_s }
  end

  private

  def game_params
    params.require(:game).permit(:home_player_id, :guest_player_id)
  end
end

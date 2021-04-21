class RoundsController < ApplicationController
  def new
    @game = Game.find_by(id: params[:game_id])
    @round = @game.new_round(category: "")
  end

  def show
    @game = Game.find_by(params[:game_id])
    @round_number = params[:id].to_i
    @round = @game.rounds.find_by(position: @round_number - 1)
  end

  def answers
    @game = Game.find_by(params[:game_id])
    @round_number = params[:id].to_i
    @round = @game.rounds.find_by(position: @round_number - 1)
  end

  def create
    @game = Game.find_by(params[:game_id])
    @round = @game.rounds.build(round_params)

    if @round.save
      format.html { redirect_to "/games/#{@game.id}/rounds/new" }
      format.json { render json: { message: "Saved" } }
    else
      format.html { render "new" }
      format.json { render json: { error: @round.errors } }
    end
  end

  def update
    @round = Round.find_by(id: params[:id])

    if @round.update(round_params)
      format.html { redirect_to @round.game }
      format.json { render json: { message: "Saved" } }
    else
      format.json { render json: { error: @round.errors } }
    end
  end

  private

  def round_params
    params.require(:round).permit(:category, :game_id, questions_attributes: [:text, :url, :answer, :position])
  end
end

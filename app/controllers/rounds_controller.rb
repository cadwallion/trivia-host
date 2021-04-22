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

  def activate
    @game = Game.find_by(id: params[:game_id])
    @round = Round.find_by(id: params[:id])
    notice = "Round #{@round.category} "
    if  @round.active != true
      @round.update(active: true)
      notice.concat("activated")
    else
      notice.concat("is already actived")
    end
    redirect_to @game, notice: notice
  end

  def deactivate
    @game = Game.find_by(id: params[:id])
    @round = Round.find_by(id: params[:id])
    notice = "Round #{@round.category} "
    if  @round.active != false
      @round.update(active: false)
      notice.concat("deactived")
    else
      notice.concat("is already deactived")
    end
    redirect_to @game, notice: notice
  end

  def complete
    @game = Game.find_by(id: params[:id])
    @round = Round.find_by(id: params[:id])
    @round.update(completed: true)
    redirect_to @game, notice: "Round #{@round.category} completed!"
  end

  def continue
    @game = Game.find_by(id: params[:id])
    @round = Round.find_by(id: params[:id])
    @round.update(completed: false)
    redirect_to @game, notice: "Round #{@round.category} continuing..."
  end

  private

  def round_params
    params.require(:round).permit(:category, :game_id, questions_attributes: [:text, :url, :answer, :position])
  end
end

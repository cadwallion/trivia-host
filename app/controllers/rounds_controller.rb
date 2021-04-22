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
    @game = Game.find_by(params[:game_id])
    @round_number = params[:id].to_i
    @round = @game.rounds.find_by(position: @round_number - 1)
    if @game.valid? && @round.valid?
      if @round.active == false
        @round.update(active: true)
        redirect_to @game, notice: "Round #{@round.category} actived"
      else
        redirect_to @game, notice: "Round #{@round.category} is already active"
      end
    else
      redirect_to @game, notice: "Game or round not found..."
    end
  end

  def deactivate
    @game = Game.find_by(params[:game_id])
    @round_number = params[:id].to_i
    @round = @game.rounds.find_by(position: @round_number - 1)
    if @game.valid? && @round.valid?
      if @round.active == true
        @round.update(active: false)
        redirect_to @game, notice: "Round #{@round.category} deactivated"
      else
        redirect_to @game, notice: "Round #{@round.category} has already been deactivated"
      end
    else
      redirect_to @game, notice: "Game or round not found..."
    end
  end

  def complete
    @game = Game.find_by(params[:game_id])
    @round_number = params[:id].to_i
    @round = @game.rounds.find_by(position: @round_number - 1)
    if @game.valid? && @round.valid?
      if @round.completed == false
        @round.update(completed: true)
        redirect_to @game, notice: "Round #{@round.category} completed"
      else
        redirect_to @game, notice: "Round #{@round.category} has already been set to complete"
      end
    else
      redirect_to @game, notice: "Game or round not found..."
    end
  end

  def continue
    @game = Game.find_by(params[:game_id])
    @round_number = params[:id].to_i
    @round = @game.rounds.find_by(position: @round_number - 1)
    if @game.valid? && @round.valid?
      if @round.completed == true
        @round.update(completed: false)
        redirect_to @game, notice: "Round #{@round.category} continuing"
      else
        redirect_to @game, notice: "Round #{@round.category} has already been set to continue"
      end
    else
      redirect_to @game, notice: "Game or round not found..."
    end
  end
  
  private

  def round_params
    params.require(:round).permit(:category, :game_id, questions_attributes: [:text, :url, :answer, :position])
  end
end

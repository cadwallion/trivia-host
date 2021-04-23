class RoundsController < ApplicationController
  before_action :load_game
  before_action :load_game_round, except: :new
  
  def new
    @round = @game.new_round(category: "")
  end

  def show
  end

  def answers
  end

  def create
    @round = @game.rounds.build(round_params)
    if @round.save
      respond_to do |format|
        format.html { redirect_to(new_game_round_path(@game)) }
        format.json { render json: { message: "Saved" } }
      end
    else
      format.html { render "new" }
      format.json { render json: { error: @round.errors } }
    end
  end

  def update
    if @round.update(round_params)
      format.html { redirect_to @round.game }
      format.json { render json: { message: "Saved" } }
    else
      format.json { render json: { error: @round.errors } }
    end
  end

  def activate
    if @round.valid?
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
    if @round.valid?
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
    if @round.valid?
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
    if @round.valid?
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
    params.require(:round).permit(:position, :category, :game_id, questions_attributes: [:text, :url, :answer, :position])
  end

  def load_game
    @game = Game.find_by(id: params[:game_id])
  end
  
  def load_game_round
    @round_number = params[:id].to_i
    @round = @game.rounds.by_round(@round_number).first
  end
end

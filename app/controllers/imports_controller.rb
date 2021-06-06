class ImportsController < ApplicationController
  def new
    @game = Game.find(params[:game_id]) 
    @importer = TriviaImporter.new(game: @game)
  end

  def create
    @game = Game.find(params[:game_id])
    @importer = TriviaImporter.new(game: @game, file: importer_params[:file].tempfile)
    if @importer.import
      @game.save
      redirect_to edit_game_path(@game), notice: "Trivia questions imported!"
    else
      flash[:error] = "Could not import trivia questions!"
      render 'new'
    end
  end

  def importer_params
    params.require(:trivia_importer).permit(:file)
  end
end

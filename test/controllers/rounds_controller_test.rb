require "test_helper"

class RoundsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "activate method activates a round" do
    @game = Game.create(name: "Test Game")
    @round = @game.rounds.create(position: 0, category: "test", round_type: "question")
    @round.save
    refute @round.active
    post activate_game_round_path(@game, @round.round_number)
    assert @round.reload.active
  end

  test "deactivate method deactivates a round" do
    @game = Game.create(name: "Test Game")
    @round = @game.rounds.create(position: 0, active: true, category: "test", round_type: "question")
    @round.save
    assert @round.active
    post deactivate_game_round_path(@game, @round.round_number)
    refute @round.reload.active
  end

  test "complete method completes a round" do
    @game = Game.create(name: "Test Game")
    @round = @game.rounds.create(position: 0, category: "test", round_type: "question")
    @round.save
    refute @round.completed
    post complete_game_round_path(@game, @round.round_number)
    assert @round.reload.completed
  end

  test "continue method continues a round" do
    @game = Game.create(name: "Test Game")
    @round = @game.rounds.create(position: 0, completed: true, category: "test", round_type: "question")
    @round.save
    assert @round.completed
    post continue_game_round_path(@game, @round.round_number)
    refute @round.reload.completed
  end
end

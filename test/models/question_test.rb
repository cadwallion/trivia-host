require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "valid with text question" do
    round = rounds(:one)
    question = Question.new(round: round, text: "What is 1+1?", answer: "2", position: 0)
    assert question.valid?
  end

  test "valid with url question" do
    round = rounds(:one)
    question = Question.new(round: round, url: "https://google.com/", answer: "2", position: 0)
    assert question.valid?
  end

  test "invalid with both text and url" do
    round = rounds(:one)
    question = Question.new(round: round, url: "https://google.com", text: "What is 1+1?", answer: "2", position: 0)
    refute question.valid?
    assert_equal "Specify a url or text, not both", question.errors[:base][0]
  end
end

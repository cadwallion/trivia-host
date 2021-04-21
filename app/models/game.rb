class Game < ApplicationRecord
  has_many :rounds, dependent: :destroy

  def new_round(category:, question_count: 10)
    round = rounds.build(position: self.rounds.length, category: category)
    question_count.times do |position|
      round.questions.build(position: position)
    end

    round
  end
end

class Game < ApplicationRecord
  has_many :rounds, dependent: :destroy do
    def by_round(round_number)
      where(position: round_number - 1)
    end
  end

  def new_round(category:, question_count: 10)
    round = rounds.build(position: self.rounds.length, category: category)
    question_count.times do |position|
      round.questions.build(position: position)
    end

    round
  end
end

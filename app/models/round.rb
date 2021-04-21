class Round < ApplicationRecord
  belongs_to :game
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions

  validates :category, presence: true
end

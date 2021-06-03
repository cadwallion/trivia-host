class Question < ApplicationRecord
  belongs_to :round

  validates :answer, presence: true
  validates :position, presence: true

  has_one_attached :picture

  validate :text_or_url

  def text_or_url
    unless url.blank? ^ text.blank?
      errors.add(:base, "Specify a url or text, not both")
    end
  end
end

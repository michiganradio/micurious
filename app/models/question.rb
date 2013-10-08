class Question < ActiveRecord::Base
  ANONYMOUS = "Anonymos"

  has_many :voting_rounds, through: :voting_round_questions
  has_many :voting_round_questions

  attr_readonly :original_text
  before_create :copy_display_text_into_original_text
  validates :display_text, length: { maximum: 140 , minimum: 1}

  def display_author
    anonymous ? ANONYMOUS : name
  end

  private
    def copy_display_text_into_original_text
      self.original_text = self.display_text
    end

end

class Question < ActiveRecord::Base
  ANONYMOUS = "Anonymous"

  has_many :voting_rounds, through: :voting_round_questions
  has_many :voting_round_questions

  has_and_belongs_to_many :categories, -> { readonly }, join_table: :questions_categories

  attr_readonly :original_text
  attr_accessor :email_confirmation
  before_create :copy_display_text_into_original_text
  validates :display_text, length: { maximum: 140 , minimum: 1}
  validates :neighbourhood, length: { maximum: 255 }, format: { with: /\A[a-zA-Z\s]*\z/, message: "only allows letters and spaces" }
  validates :name, length: {maximum: 255, minimum: 1 }, format: { with: /\A[a-zA-Z\s]+\z/, message: "only allows letters and spaces" }
  validates :email, length: {maximum: 255}, confirmation: true, email: true


  def display_author
    anonymous ? ANONYMOUS : name
  end

  private
    def copy_display_text_into_original_text
      self.original_text = self.display_text
    end

end

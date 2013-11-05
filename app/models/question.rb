class Question < ActiveRecord::Base
  ANONYMOUS = "Anonymous"

  has_many :voting_rounds, through: :voting_round_questions
  has_many :voting_round_questions
  has_many :answers
  has_many :completed_answers, -> { where type: Answer::Type::Answer }, class_name: 'Answer'
  has_many :updates, -> { where type: Answer::Type::Update }, class_name: 'Answer'
  has_and_belongs_to_many :categories, -> { readonly }, join_table: :questions_categories
  accepts_nested_attributes_for :answers

  attr_readonly :original_text
  attr_accessor :email_confirmation
  before_create :copy_display_text_into_original_text
  validates :display_text, length: { maximum: 140 , minimum: 1}
  validates :neighbourhood, length: { maximum: 255 }, format: { with: /\A[a-zA-Z\s]*\z/, message: "only allows letters and spaces" }
  validates :name, length: {maximum: 255, minimum: 1 }, format: { with: /\A[a-zA-Z\s\.\-'@]+\z/, message: "only allows letters, spaces, periods, hyphens, apostrophes, and @ signs" }
  validates :email, length: {maximum: 255}, confirmation: true, email: true
  validates :email_confirmation, presence: true, on: :create

  scope :with_category, ->(category_name) { includes(:categories).where(categories: {name: category_name}).order(created_at: :desc) }

  def display_author
    anonymous ? ANONYMOUS : name
  end

  def picture_url
    if !new_record? and read_attribute(:picture_url).to_s == ''
      "/assets/default-question-picture.jpg"
    else
      read_attribute(:picture_url)
    end
  end

  def in_active_voting_rounds?
    ([VotingRound::Status::New, VotingRound::Status::Live] & self.voting_rounds.map(&:status)).any?
  end

  private

  def copy_display_text_into_original_text
    self.original_text = self.display_text
  end
end

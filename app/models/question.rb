class Question < ActiveRecord::Base
  ANONYMOUS = "Anonymous"

  has_many :voting_rounds, through: :voting_round_questions
  has_many :voting_round_questions
  has_many :answers, autosave: true
  has_many :completed_answers, -> { where type: Answer::Type::Answer }, class_name: 'Answer'
  has_many :updates, -> { where type: Answer::Type::Update }, class_name: 'Answer'
  has_and_belongs_to_many :categories, -> { readonly }, join_table: :questions_categories
  accepts_nested_attributes_for :answers
  before_update :set_tags_updated_at_if_tags_changed
  before_update :set_notes_updated_at_if_notes_changed
  attr_readonly :original_text
  attr_accessor :email_confirmation
  before_create :copy_display_text_into_original_text
  validates :display_text, length: { maximum: 2000, minimum: 1}
  validates :neighbourhood, length: { maximum: 100 }
  validates :name, length: {maximum: 255, minimum: 1 }, format: { with: /\A[a-zA-Z\s\.\-'@]+\z/, message: "only allows letters, spaces, periods, hyphens, apostrophes, and @ signs" }
  validates :email, length: {maximum: 255}, confirmation: true, email: true
  validates :email_confirmation, presence: true, on: :create

  def self.with_status_and_category(status, category_name)
    if category_name.present?
      includes(:categories).where(categories: {name: category_name}, status: status).order(created_at: :desc)
    else
      where(status: status).order(created_at: :desc)
    end
  end

 module Status
   New = "New"
   Answered = "Answered"
   Investigating = "Investigating"
   Removed = "Removed"
   All = [New, Answered, Investigating, Removed]
 end

  def active?
    status != Question::Status::Removed
  end

  def answered?
    status == Question::Status::Answered
  end

  def investigating?
    status == Question::Status::Investigating
  end

  def display_author
    anonymous ? ANONYMOUS : name
  end

  def in_active_voting_rounds?
    ([VotingRound::Status::New, VotingRound::Status::Live] & self.voting_rounds.map(&:status)).any?
  end

  def previous_question
    Question.where('status != "Removed" AND id<'+(self.id).to_s).order(id: :desc).first
  end

  def next_question
    Question.where('status != "Removed" AND id>'+(self.id).to_s).order(id: :asc).first
  end

  private

  def set_tags_updated_at_if_tags_changed
    time = Time.new
    self.tags_updated_at = time.inspect unless self.tags == Question.find(self.id).tags
  end

  def set_notes_updated_at_if_notes_changed
    time = Time.new
    self.notes_updated_at = time.inspect unless self.notes == Question.find(self.id).notes
 end

  def copy_display_text_into_original_text
    self.original_text = self.display_text unless self.original_text.present?
  end
end

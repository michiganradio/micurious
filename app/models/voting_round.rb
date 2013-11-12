class VotingRound < ActiveRecord::Base
  has_many :voting_round_questions
  has_many :questions, through: :voting_round_questions, autosave: true

  after_save :add_default_label_if_empty

  validates :label, uniqueness: { case_sensitive: false }
  validate :only_one_live_status

  module Status
    New = "New"
    Live = "Live"
    Completed = "Completed"
    Deactivated = "Deactivated"
    All = [New, Live, Completed, Deactivated]
  end

  def add_question(question)
    self.questions.push(question)
  end

  def get_previous
   prev = VotingRound.where('status = "Completed" and start_time < "' + self.start_time.to_s + '"').order(start_time: :desc).first
  end

  private

  def add_default_label_if_empty
    self.update_attributes(label: "Voting Round " + self.id.to_s) if self.label.to_s == ''
  end

  def only_one_live_status
    if self.status == VotingRound::Status::Live and (VotingRound.where(status:VotingRound::Status::Live) - [self]).any?
      errors.add(:base, "Only one voting round can have live status")
    end
  end
end

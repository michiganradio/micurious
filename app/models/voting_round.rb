class VotingRound < ActiveRecord::Base
  has_many :voting_round_questions
  has_many :questions, through: :voting_round_questions, autosave: true

  after_save :add_default_public_label_if_empty
  after_save :add_default_private_label_if_empty
  before_update :update_winning_question_status

  validates :public_label, uniqueness: { case_sensitive: false }
  validates :private_label, uniqueness: { case_sensitive: false }
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

  def previous
   VotingRound.where('status = "Completed" and start_time < "' + self.start_time.to_s + '"').order(start_time: :desc).first
  end

  def next
   VotingRound.where('(status = "Live" or status = "Completed") and start_time > "' + self.start_time.to_s + '"').order(start_time: :asc).first
  end

  def winner
    return [] if voting_round_questions.empty?
    max_votes = voting_round_questions.maximum('vote_number')
    winning_vr_questions = voting_round_questions.select{ |vr_question| vr_question.vote_number == max_votes }
    winners = winning_vr_questions.map{ |vr_question| vr_question.question }
  end

  def vote_percentage(question)
    voting_round_question = voting_round_questions.select{ |vr_question| vr_question.question_id == question.id }[0]
    votes = voting_round_question.vote_number
    total_votes = voting_round_questions.map(&:vote_number).inject(0) { |x,y| x + y }
    return total_votes==0 ? 0 : ((votes * 100.0)/total_votes).round
  end

  private

    def add_default_public_label_if_empty
      self.update_attributes(public_label: "Voting Round #{self.id}") if self.public_label.to_s == ''
    end

    def add_default_private_label_if_empty
      self.update_attributes(private_label: "Voting Round #{self.id}") if self.private_label.to_s == ''
    end

    def only_one_live_status
      if self.status == VotingRound::Status::Live and (VotingRound.where(status:VotingRound::Status::Live) - [self]).any?
        errors.add(:base, "Only one voting round can have live status")
      end
    end

    def update_winning_question_status
      previous_state = VotingRound.find(self.id)
      if previous_state.status == VotingRound::Status::Live && self.status == VotingRound::Status::Completed
        self.winner.each { |question| question.update(status: Question::Status::Investigating) }
      end
    end
end

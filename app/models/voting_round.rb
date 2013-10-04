class VotingRound < ActiveRecord::Base
  has_many :voting_round_questions
  has_many :questions, through: :voting_round_questions

  def add_question(question)
    self.questions.push(question)
  end
end

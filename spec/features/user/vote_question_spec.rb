require 'spec_helper'

describe "Vote on a question" do
  subject { page }

  before { 
    @question = FactoryGirl.create(:question)
    voting_round = FactoryGirl.create(:voting_round)
    FactoryGirl.create(:voting_round_question, question_id: @question.id,
                                                     voting_round_id: voting_round.id)
    visit root_path
  }

  describe "have vote link" do
    it { should have_link ('Vote'+@question.id.to_s) }
  end

end

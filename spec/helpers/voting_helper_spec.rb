require 'spec_helper'

describe VotingHelper do

  before(:each) do 
    @question = FactoryGirl.create(:question)
  end

  specify "#last_vote?" do
    cookies.permanent[:question_id] = @question.id
    expect(last_vote?(@question.id)).to eq true
    expect(last_vote?(-1)).to eq false
  end
end

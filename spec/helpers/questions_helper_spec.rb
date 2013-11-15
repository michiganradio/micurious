require 'spec_helper'

describe QuestionsHelper do

  describe "cache_key_for_questions" do
    it "returns a key based on the requests params and results" do
      last_updated_at = Time.now
      questions = double(:question, count: 2)
      questions.stub(:maximum).with(:updated_at).and_return(last_updated_at)
      helper.stub(:params).and_return({:status => "status",
                                       :category_name => "category_name"})
      helper.cache_key_for_questions(questions).should == "questions-status-category_name-2-#{last_updated_at.utc.to_s(:number)}"
    end
  end
end

require 'spec_helper'

describe "question detail" do
  describe "GET questions with id" do
    it "shows question details" do
      question = FactoryGirl.create(:question)
      get question_path(question)
      expect(response.body).to include question.display_text
      expect(response.body).to include question.display_author
    end
  end
end

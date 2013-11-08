require 'spec_helper'

describe ApplicationHelper do
  describe :badge_class do
    context "question is answered" do
      it "returns checkmark class" do
        question = Question.new(status: Question::Status::Answered)
        helper.badge_class(question).should == "checkmark"
      end
    end
    context "question is investigating" do
      it "returns questionmark class" do
        question = Question.new(status: Question::Status::Investigating)
        helper.badge_class(question).should == "questionmark"
      end
    end

    context "question is other" do
      it "return nil" do
        question = Question.new(status: Question::Status::New)
        helper.badge_class(question).should be_nil
      end
    end
  end
end

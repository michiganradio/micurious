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

  describe "question_image_url" do
    context "question picture_url present" do
      it "returns question picture_url" do
        question = Question.new(picture_url: "someurl")
        helper.question_image_url(question).should == question.picture_url
      end
    end

    context "question picture_url not present" do
      it "returns default picture" do
        question = Question.new(picture_url: "")
        helper.question_image_url(question).should == helper.image_url("default-question-picture.jpg")
      end
    end
  end

  describe "question_display_text" do
    context "question.display_text is over 140 characters" do
      it "cuts the text to 140 and appends ..." do
        question = Question.new(display_text: "a"*141)
        helper.question_display_text(question).should == "a"*140+"..."
      end
    end

    context "question.display_text is under 140 characters" do
      it "keeps the text" do
        question = Question.new(display_text: "a"*140)
        helper.question_display_text(question).should == "a"*140
      end
    end
  end
end

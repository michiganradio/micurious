require 'spec_helper'

describe Question do

  before do
    @question = Question.new(original_text: "question original text here",
                              display_text: "question display text here")
  end

  subject{ @question }

  it { should respond_to(:original_text) }
  it { should respond_to(:display_text) }

  describe "display_text" do
    context "larger than 500 characters" do
      it "throws an error" do
        invalid_text = "0" * 501
        @question.display_text = invalid_text
        expect(@question).not_to be_valid
      end
    end
  end

  describe "original_text" do
    context "larger than 500 characters" do
      it "throws an error" do
        invalid_text = "0" * 501
        @question.original_text = invalid_text
        expect(@question).not_to be_valid
      end
    end
  end

end

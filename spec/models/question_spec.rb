require 'spec_helper'

describe Question do

  before do
    @question = Question.new(display_text: "question display text here")
  end

  subject{ @question }

  describe "display_text" do
    context "larger than 500 characters" do
      it "throws an error" do
        invalid_text = "0" * 501
        @question.display_text = invalid_text
        expect(@question).not_to be_valid
      end
    end
  end

end

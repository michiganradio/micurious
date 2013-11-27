require 'spec_helper'

describe Admin::QuestionsHelper do
  describe "display_tags" do
    it "concats tag names with comma" do
      question= Question.new
      question.tag_list = "a, b, c"
      helper.display_tags(question).should == "a, b, c"
    end
  end

end

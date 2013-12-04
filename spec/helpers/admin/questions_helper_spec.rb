require 'spec_helper'

describe Admin::QuestionsHelper do
  describe "display_tags" do
    it "concats tag names with comma" do
      question= Question.new
      question.tag_list = "a, b, c"
      helper.display_tags(question).should == "a, b, c"
    end
  end

  describe "display_date" do
    it "converts the date to MonddYYYY format" do
      date = DateTime.new(2013, 3, 4, 0, 0, 0)
      helper.display_date(date).should == "03/04/2013"
    end
  end
end

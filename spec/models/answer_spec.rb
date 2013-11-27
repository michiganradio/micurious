require 'spec_helper'

describe Answer do
  describe "validation" do
    context "label" do
      it { should ensure_length_of(:label).
            is_at_least(1).
            is_at_most(3000) }
    end

    context "url" do
      it { should ensure_length_of(:url).
           is_at_least(1).
           is_at_most(2000) }
    end

    context "type" do
      it { should validate_presence_of(:type) }
    end
  end

  describe "recent_answer" do
      it "returns recent updated answers" do
        @most_recent_answers = [Answer.new]
        Answer.stub_chain(:where, :order, :limit).and_return(@most_recent_answers)
        Answer.recent_answers.should == @most_recent_answers
      end
  end

  describe "recent_update" do
      it "returns recent updated updates" do
        @most_recent_updates = [Answer.new]
        Answer.stub_chain(:where, :order, :limit).and_return(@most_recent_updates)
        Answer.recent_updates.should == @most_recent_updates
      end
  end
end

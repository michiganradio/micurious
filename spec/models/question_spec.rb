require 'spec_helper'

describe Question do
  subject {@question}

  context "original_text" do
    before do
      @question = FactoryGirl.create(:question)
    end

    it "no updating the original_text" do
      original_text = @question.original_text
      @question.update_attributes :original_text => original_text + "new"
      @question.reload.original_text.should eql original_text
    end

    its('original_text') { should eq @question.display_text }
  end

  context "display_text" do
    before do
      @question = FactoryGirl.build(:question)
    end

    it { should respond_to(:display_text) }
    it { should ensure_length_of(:display_text).
          is_at_least(1).
          is_at_most(140) }
  end

  context "display_author" do
    context "when the question is submitted anonymously" do
      it "displays the name" do
        @question = FactoryGirl.build(:question, :anonymous)
        @question.display_author.should == Question::ANONYMOUS
      end
    end

    context "when the question is not submitted anonymously" do
      it "displays the name" do
        @question = FactoryGirl.build(:question)
        @question.display_author.should == @question.name
      end
    end
  end

end

require 'spec_helper'

describe Question do

  before do
    @question = Question.create(display_text: "question display text here")
  end

  subject{ @question }

  context "original_text" do
    it { should respond_to(:original_text) }
    it "no updating the original_text" do
      @question.update_attributes :original_text => 'bar'
      @question.reload.original_text.should eql 'question display text here'
    end
    
    its('original_text') { should eq @question.display_text } 
  end

  context "display_text" do
    it { should respond_to(:display_text) }
    it { should ensure_length_of(:display_text).
          is_at_least(1).   
          is_at_most(500) }
  end

  it { should respond_to(:name) }
  it { should respond_to(:neighbourhood) }
  it { should respond_to(:email) }
  it { should respond_to(:anonymous) }
end

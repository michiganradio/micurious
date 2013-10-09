require 'spec_helper'

describe 'View all questions' do
  subject { page }

  before do
    @question = FactoryGirl.create(:question)
    @anonymous_question = FactoryGirl.create(:question, :anonymous)
    @question.display_text = "new display text"
    @anonymous_question.display_text = "anonymous display text"
    @question.save
    @anonymous_question.save
    visit questions_path
  end

  describe "display user-visible question fields" do
    it { should have_content(@question.display_text) }
    it { should have_content(@question.name) }
  end

  describe "user-invisible question fields" do
    it { should_not have_content(@question.original_text) }
  end

  describe "anonymous question" do
    it { should_not have_content(@anonymous_question.name) }
    it { should have_content("Anonymous") }
  end
end

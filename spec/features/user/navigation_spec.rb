require 'features/features_spec_helper'

describe "Navigation" do

  subject { page }
  before(:each) do
    FactoryGirl.create(:category, :name => "life-style", :label => "life style")
    @home = Home.new
    @home.load
  end

  it "has up for voting link" do
    @home.up_for_voting_link.text.should == 'Up for Voting'
  end

  it "has Answered and Investigating link" do
    @home.answered_and_investigating_link.text.should == "Answered & Investigating"
  end

  it "has New and Unanswered link" do
    @home.new_and_unanswered_link.text.should == "New & Unanswered"
  end

  it "has categories dropdown" do
    @home.has_answered_and_investigation_categories_dropdown?
  end

  describe "has categories links" do
    before do
      @category1 = FactoryGirl.create(:category, active: true)
      @category2 = FactoryGirl.create(:category, :other)
    end
    shared_examples_for "question browsing pages" do
      describe "has navigation links" do
        it { should have_link("All", href: filter_questions_path) }
        it { should have_link(@category1.label, href: filter_questions_path(@category1.name)) }
        it { should have_link(@category2.label, href: filter_questions_path(@category2.name)) }
      end
    end

    describe "main question browsing page" do
      before do
        visit filter_questions_path
      end
      it_should_behave_like 'question browsing pages'
    end

    describe "filtered question browsing page" do
      before do
        visit filter_questions_path(@category1.name)
      end
      it_should_behave_like 'question browsing pages'
    end
  end
end

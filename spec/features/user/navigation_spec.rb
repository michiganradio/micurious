require 'spec_helper'

describe "Navigation" do

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
    @home.new_and_unanswered_link.text.should == "New and Unanswered"
  end

  it "has categories dropdown" do
    @home.has_answered_and_investigation_categories_dropdown?
  end
end

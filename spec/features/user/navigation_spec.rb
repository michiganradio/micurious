require 'spec_helper'

describe "Navigation" do
  subject { page }

  before(:each) do
    FactoryGirl.create(:category, :name => "life-style", :label => "life style")
    visit root_url
  end

  specify "has up for voting link" do
    should have_link("Up for Voting")
  end

  specify "has Answered and Investigating link" do
    should have_link("Answered & Investigating")
  end

  specify "has New and Unanswered link" do
    should have_link("New and Unanswered")
  end

  specify "has categories dropdown" do
    should have_selector("li.dropdown ul li a", :text => "life style", :visible => true)
  end
end

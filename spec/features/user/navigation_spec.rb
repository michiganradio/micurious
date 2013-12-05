=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
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
        @status = "archive"
    end

    shared_examples_for "question browsing pages" do
      describe "has navigation links" do
        it { should have_link("All", href: filter_questions_path(status: @status)) }
        it { should have_link(@category1.label, href: filter_questions_path(status: @status, category_name: @category1.name)) }
        it { should have_link(@category2.label, href: filter_questions_path(status: @status, category_name: @category2.name)) }
      end
    end

    describe "main question browsing page" do
      before do
        visit filter_questions_path(status: @status)
      end
      it_should_behave_like 'question browsing pages'
    end

    describe "filtered question browsing page" do
      before do
        visit filter_questions_path(status: @status, category_name: @category1.name)
      end
      it_should_behave_like 'question browsing pages'
    end
  end

  it "has social media links" do
    @home.should have_link("", href: "http://wbezcuriouscity.tumblr.com")
    @home.should have_link("", href: "http://www.facebook.com/curiouscityproject")
    @home.should have_link("", href: "https://twitter.com/wbezcuriouscity")
  end
end

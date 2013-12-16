=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "ask question on mobile" do
  it  "submits a valid question" do
    @user_ask_mobile_page = AskMobile.new
    @user_ask_mobile_page.load
    @user_ask_mobile_page.name.set "Person"
    @user_ask_mobile_page.email.set "person@aol.com"
    @user_ask_mobile_page.neighbourhood.set "Chicago"
    @user_ask_mobile_page.anonymous.click
    @user_ask_mobile_page.display_text.set "Question?"

    @user_ask_mobile_page.submit_button.click

    @user_submit_mobile_page = SubmitMobile.new
    @user_submit_mobile_page.should be_displayed
    @user_submit_mobile_page.vote_link.text.should == 'Vote'
    @user_submit_mobile_page.browse_answers_link.text.should == 'Browse Answers'
    @user_submit_mobile_page.browse_questions_link.text.should == 'Browse Questions'

  end

end

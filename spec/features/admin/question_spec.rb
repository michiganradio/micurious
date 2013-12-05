=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe "admin's questions page" do
  it "displays question created_at, notes and tags" do
    signin_as_admin
    @question  = FactoryGirl.create(:question, created_at: "Dec 5, 2013", picture_url: "picture_url",
                             picture_owner: "picture_owner",
                             picture_attribution_url: "picture_attribution_url",
                             notes: "question notes",
                             tag_list: "chicago, weather")

    @admin_questions = Admin::Questions.new
    @admin_questions.load
    @admin_questions.should have_content("question notes")
    @admin_questions.should have_content("12/05/2013")
    @admin_questions.should have_content("chicago")
    @admin_questions.should have_link("chicago")
    @admin_questions.should have_link("weather")
  end
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'features/features_spec_helper'

describe 'admin edit question', js: true do
  context "user has admin privileges" do
    it 'modifies the picture attribution, url, and owner' do
      signin_as_admin
      @question  = FactoryGirl.create(:question, picture_url: "picture_url",
                                      picture_owner: "picture_owner",
                                      picture_attribution_url: "picture_attribution_url")
      @admin_edit_question = Admin::EditQuestion.new
      @admin_edit_question.load(id: @question.id)
      @admin_edit_question.picture_url.set("new picture_url")
      @admin_edit_question.picture_owner.set("new owner")
      @admin_edit_question.picture_attribution_url.set("new attribution_url")
      @admin_edit_question.reporter.set("reporter_name")
      @admin_edit_question.status_dropdown.select("Removed")
      @admin_edit_question.notes.set("notes here")
      @admin_edit_question.tags.set("tags here")
      @admin_edit_question.featured.click
      @admin_edit_question.update_question_button.click

      @admin_show_question = Admin::ShowQuestion.new
      @admin_show_question.should have_content("reporter_name")
      @admin_show_question.should have_content("Removed")
      @admin_show_question.should have_content("notes here")
      @admin_show_question.should have_content("tags here")

      @admin_edit_question.load(id: @question.id)
      @admin_edit_question.picture_url[:value].should == "new picture_url"
      @admin_edit_question.featured.should be_checked
    end
  end
  context "user has no admin privileges" do
    it "only allows editing of notes and tags" do
      signin_as_reporter
      @question  = FactoryGirl.create(:question, picture_url: "picture_url",
                                      picture_owner: "picture_owner",
                                      picture_attribution_url: "picture_attribution_url")

      @admin_edit_question = Admin::EditQuestion.new
      @admin_edit_question.load(id: @question.id)

      @admin_edit_question.notes.set("notes here")
      @admin_edit_question.tags.set("tags here")
      @admin_edit_question.should have_no_picture_url
      @admin_edit_question.should have_no_featured
      @admin_edit_question.update_question_button.click

      @admin_show_question = Admin::ShowQuestion.new
      @admin_show_question.should have_content("notes here")
      @admin_show_question.should have_content("tags here")

    end
  end
end

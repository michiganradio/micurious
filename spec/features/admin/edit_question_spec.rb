require 'features/features_spec_helper'

# TODO: Have to enable js to get checkbox working, need to investigate why
describe 'admin edit question', js: true do
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
    @admin_edit_question.featured.click
    @admin_edit_question.update_question_button.click


    @admin_show_question = Admin::ShowQuestion.new
    @admin_show_question.should have_content("reporter_name")
    @admin_show_question.should have_content("Removed")

    @admin_edit_question.load(id: @question.id)
    @admin_edit_question.picture_url[:value].should == "new picture_url"
    @admin_edit_question.featured.should be_checked


  end
end

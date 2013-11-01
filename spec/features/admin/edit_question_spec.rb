require 'features/features_spec_helper'

describe 'admin edit question' do
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
    @admin_edit_question.update_question_button.click

    @admin_edit_question.load(id: @question.id)
    @admin_edit_question.picture_url[:value].should == "new picture_url"


  end
end

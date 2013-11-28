require 'features/features_spec_helper'

describe "admin's questions page" do
  it "displays question notes and tags" do
    signin_as_admin
    @question  = FactoryGirl.create(:question, picture_url: "picture_url",
                             picture_owner: "picture_owner",
                             picture_attribution_url: "picture_attribution_url",
                             notes: "question notes",
                             tag_list: "chicago, weather")

    @admin_questions = Admin::Questions.new
    @admin_questions.load
    @admin_questions.should have_content("question notes")
    @admin_questions.should have_content("chicago")
    @admin_questions.should have_link("chicago")
    @admin_questions.should have_link("weather")
  end
end

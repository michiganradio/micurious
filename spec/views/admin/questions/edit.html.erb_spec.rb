require 'spec_helper'

describe "admin/questions/edit" do
  before(:each) do
    @question = assign(:question, FactoryGirl.build(:question))
    @categories = assign(:categories, [FactoryGirl.build(:category)])
  end

  it "renders the edit question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_question_path(@question), "post" do
      assert_select "textarea#question_display_text[name=?]", "question[display_text]"
    end
  end
end

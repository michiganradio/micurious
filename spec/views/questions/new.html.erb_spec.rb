require 'spec_helper'

describe "questions/new" do
  before(:each) do
    assign(:question, stub_model(Question,
      :original_text => "MyText",
      :display_text => "MyText"
    ).as_new_record)
  end

  it "renders new question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", questions_path, "post" do
      assert_select "textarea#question_original_text[name=?]", "question[original_text]"
      assert_select "textarea#question_display_text[name=?]", "question[display_text]"
    end
  end
end

require 'spec_helper'

describe "home" do
  before(:each) do
    assign(:question, stub_model(Question,
       :display_text => "MyText")
       .as_new_record)
  end

# it "renders main page" do
#   response.should have_tag('form[action=?][method=?]', new_questions_path, "post")
# end
end


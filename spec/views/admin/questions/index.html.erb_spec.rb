require 'spec_helper'

describe "admin/questions/index" do
  before(:each) do
    assign(:questions, [
      stub_model(Question,
        :original_text => "question",
        :display_text => "display_question1"
      ),
      stub_model(Question,
        :original_text => "question",
        :display_text => "display_question2"
      )
    ])
  end

  it "renders a list of questions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "question".to_s, :count => 2
  end
end

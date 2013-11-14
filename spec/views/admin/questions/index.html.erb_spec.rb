require 'spec_helper'

describe "admin's questions index page" do
  before(:each) do
    assign(:questions, [
      stub_model(Question,
        :original_text => "question",
        :display_text => "display_question"
      ),
      stub_model(Question,
        :original_text => "question",
        :display_text => "display_question"
      )
    ])
  end

  it "renders a list of questions" do
    render
    assert_select "tr>td", :text => "display_question".to_s, :count => 2
  end
end

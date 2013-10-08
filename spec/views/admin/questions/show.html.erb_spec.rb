require 'spec_helper'

describe "admin/questions/show" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :original_text => "MyText",
      :display_text => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
  end
end

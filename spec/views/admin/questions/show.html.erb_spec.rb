require 'spec_helper'

describe "admin/questions/show" do
  before(:each) do
    @question = assign(:question, FactoryGirl.build(:question))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{@question.original_text}/)
    rendered.should match(/#{@question.display_text}/)
    rendered.should match(/#{@question.picture_url}/)
    rendered.should match(/#{@question.picture_attribution_url}/)
  end
end

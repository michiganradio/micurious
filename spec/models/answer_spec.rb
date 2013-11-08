require 'spec_helper'

describe Answer do
  describe "validation" do
    context "label" do
      it { should ensure_length_of(:label).
            is_at_least(1).
            is_at_most(3000) }
    end

    context "url" do
      it { should ensure_length_of(:url).
           is_at_least(1).
           is_at_most(2000) }
    end

    context "type" do
      it { should validate_presence_of(:type) }
    end
  end
end

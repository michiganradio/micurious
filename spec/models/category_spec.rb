require 'spec_helper'

describe Category do
  describe "validates name" do
    it "validates letters" do
      Category.new(name: "abcd").should be_valid
      Category.new(name: "ab cd").should_not be_valid
    end

    it "validates dash" do
      Category.new(name: "dash-dash").should be_valid
      Category.new(name: "dash'dash").should_not be_valid
    end
  end
end

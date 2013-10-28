require 'spec_helper'

describe ApplicationController do
  describe "load_categories" do
    it "assigns all active categories as @categories" do
      categories = [double(:category)]
      Category.stub(:where).with(active:true).and_return(categories)
      subject.load_categories
      assigns(:categories).should eq categories
    end
  end
end

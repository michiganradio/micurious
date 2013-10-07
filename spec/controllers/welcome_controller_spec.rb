require 'spec_helper'

describe WelcomeController do

  describe "GET home" do
    it "gets the home page" do
      get :home, {}, {}
    end
  end
end

require "spec_helper"

describe VotingRoundsController do
  describe "routing" do

    it "routes to #index" do
      get("/voting_rounds").should route_to("voting_rounds#index")
    end

    it "routes to #new" do
      get("/voting_rounds/new").should route_to("voting_rounds#new")
    end

    it "routes to #show" do
      get("/voting_rounds/1").should route_to("voting_rounds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/voting_rounds/1/edit").should route_to("voting_rounds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/voting_rounds").should route_to("voting_rounds#create")
    end

    it "routes to #update" do
      put("/voting_rounds/1").should route_to("voting_rounds#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/voting_rounds/1").should route_to("voting_rounds#destroy", :id => "1")
    end

  end
end

require "spec_helper"

describe Admin::VotingRoundsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/voting_rounds").should route_to("admin/voting_rounds#index")
    end

    it "routes to #new" do
      get("/admin/voting_rounds/new").should route_to("admin/voting_rounds#new")
    end

    it "routes to #show" do
      get("/admin/voting_rounds/1").should route_to("admin/voting_rounds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/voting_rounds/1/edit").should route_to("admin/voting_rounds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/voting_rounds").should route_to("admin/voting_rounds#create")
    end

    it "routes to #update" do
      put("/admin/voting_rounds/1").should route_to("admin/voting_rounds#update", :id => "1")
    end

  end
end

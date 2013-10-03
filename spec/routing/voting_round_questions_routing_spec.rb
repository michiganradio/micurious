require "spec_helper"

describe VotingRoundQuestionsController do
  describe "routing" do

    it "routes to #index" do
      get("/voting_round_questions").should route_to("voting_round_questions#index")
    end

    it "routes to #new" do
      get("/voting_round_questions/new").should route_to("voting_round_questions#new")
    end

    it "routes to #show" do
      get("/voting_round_questions/1").should route_to("voting_round_questions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/voting_round_questions/1/edit").should route_to("voting_round_questions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/voting_round_questions").should route_to("voting_round_questions#create")
    end

    it "routes to #update" do
      put("/voting_round_questions/1").should route_to("voting_round_questions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/voting_round_questions/1").should route_to("voting_round_questions#destroy", :id => "1")
    end

  end
end

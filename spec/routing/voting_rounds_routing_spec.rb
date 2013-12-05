=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
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

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require "spec_helper"

describe Admin::QuestionsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/questions").should route_to("admin/questions#index")
    end

    it "routes to #new" do
      get("/admin/questions/new").should route_to("admin/questions#new")
    end

    it "routes to #show" do
      get("/admin/questions/1").should route_to("admin/questions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/questions/1/edit").should route_to("admin/questions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/questions").should route_to("admin/questions#create")
    end

    it "routes to #update" do
      put("/admin/questions/1").should route_to("admin/questions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/questions/1").should route_to("admin/questions#destroy", :id => "1")
    end

  end
end

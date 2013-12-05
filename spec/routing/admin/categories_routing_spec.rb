=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require "spec_helper"

describe Admin::CategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/categories").should route_to("admin/categories#index")
    end

    it "routes to #new" do
      get("/admin/categories/new").should route_to("admin/categories#new")
    end

    it "routes to #show" do
      get("/admin/categories/1").should route_to("admin/categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/categories/1/edit").should route_to("admin/categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/categories").should route_to("admin/categories#create")
    end

    it "routes to #update" do
      put("/admin/categories/1").should route_to("admin/categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/categories/1").should route_to("admin/categories#destroy", :id => "1")
    end

  end
end

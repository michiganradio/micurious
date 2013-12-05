=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'
describe Admin::CategoriesController do

  let(:valid_attributes) { { "name" => "MyString", "active" => true } }
  let(:valid_session) { {} }

  before do
    subject.stub(:ssl_configured).and_return(false)
    subject.stub(:signed_in_admin)
    request.env['HTTPS'] = 'on'
  end

  describe "GET index" do
    it "assigns all admin_categories as @admin_categories" do
      category = Category.create! valid_attributes
      get :index, {}, valid_session
      assigns(:admin_categories).should eq([category])
    end

    context "without SSL" do
      it "returns an error" do
        request.env['HTTPS'] = 'off'
        subject.stub(:ssl_configured).and_return(true)
        get :index, {}, valid_session
        expect(response.status).to eq 301
      end
    end
  end

  describe "GET show" do
    it "assigns the requested admin_category as @admin_category" do
      category = Category.create! valid_attributes
      get :show, {:id => category.to_param}, valid_session
      assigns(:admin_category).should eq(category)
    end
  end

  describe "GET new" do
    context "when user has admin privileges" do
      it "assigns a new admin_category as @admin_category" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
        get :new, {}, valid_session
        assigns(:admin_category).should be_a_new(Category)
      end
    end
    context "when user does not have admin privileges" do
      it "returns an error" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
        get :new, {}, valid_session
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET edit" do
    context "when user has admin privileges" do
    it "assigns the requested admin_category as @admin_category" do
      subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
      category = Category.create! valid_attributes
      get :edit, {:id => category.to_param}, valid_session
      assigns(:admin_category).should eq(category)
    end
    end
    context "when user does not have admin privileges" do
      it "returns an error" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
        category = Category.create! valid_attributes
        get :edit, {:id => category.to_param}, valid_session
        expect(response.status).to eq 401

      end
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, {:admin_category => valid_attributes}, valid_session
        }.to change(Category, :count).by(1)
      end

      it "assigns a newly created admin_category as @admin_category" do
        post :create, {:admin_category => valid_attributes}, valid_session
        assigns(:admin_category).should be_a(Category)
        assigns(:admin_category).should be_persisted
      end

      it "redirects to the created admin_category" do
        post :create, {:admin_category => valid_attributes}, valid_session
        response.should redirect_to(admin_category_url(Category.last))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved admin_category as @admin_category" do
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        post :create, {:admin_category => { "name" => "invalid value" }}, valid_session
        assigns(:admin_category).should be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        post :create, {:admin_category => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    context "with valid params" do
      it "updates the requested admin_category" do
        category = Category.create! valid_attributes
        # Assuming there are no other admin_categories in the database, this
        # specifies that the Category created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Category.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => category.to_param, :admin_category => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested admin_category as @admin_category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :admin_category => valid_attributes}, valid_session
        assigns(:admin_category).should eq(category)
      end

      it "redirects to the admin_category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :admin_category => valid_attributes}, valid_session
        response.should redirect_to(admin_category_url(category))
      end
    end

    context "with invalid params" do
      it "assigns the admin_category as @admin_category" do
        category = Category.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        put :update, {:id => category.to_param, :admin_category => { "name" => "invalid value" }}, valid_session
        assigns(:admin_category).should eq(category)
      end

      it "re-renders the 'edit' template" do
        category = Category.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        put :update, {:id => category.to_param, :admin_category => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "POST deactivate" do
    context "when user has admin privileges" do
      it "deactivates the requested admin_category" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
        category = Category.create! valid_attributes
        expect {
          post :deactivate, {:id => category.to_param}, valid_session
        }.to change{ Category.where(active: true).count}.by(-1)
      end

      it "redirects to the admin_categories list" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
        category = Category.create! valid_attributes
        post :deactivate, {:id => category.to_param}, valid_session
        response.should redirect_to(admin_categories_url)
      end
    end
    context "when user does not have admin privileges" do
      it "returns an error" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
        category = Category.create! valid_attributes
        post :deactivate, {:id => category.to_param}, valid_session
        expect(response.status).to eq 401
      end
    end
  end
end

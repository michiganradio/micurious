=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe Admin::UsersController do

  let(:valid_attributes) { { "username" => "MyString", "password" => "password", "password_confirmation" => "password" } }
  let(:valid_session) { {} }

  before do
    request.env['HTTPS'] = 'on'
    subject.stub(:signed_in_admin)
  end

  describe "GET index without SSL" do
    it "returns an error" do
      subject.stub(:ssl_configured).and_return(true)
      request.env['HTTPS'] = 'off'
      get :index
      expect(response.status).to eq 301
    end
  end
  describe "GET index" do
    it "assigns all admins as @admins" do
      admin = User.create! valid_attributes
      get :index, {}, valid_session
      assigns(:admins).should eq([admin])
    end
  end

  describe "GET show" do
    it "assigns the requested admin as @admin" do
      admin = User.create! valid_attributes
      get :show, {:id => admin.to_param}, valid_session
      assigns(:admin).should eq(admin)
    end
  end

  describe "GET new" do
    context "user has admin privileges" do
      it "assigns a new admin as @admin" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user))
        get :new, {}, valid_session
        assigns(:admin).should be_a_new(User)
      end
    end

    context "user does not have admin privileges" do
      it "returns an error" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter))
        get :new, {}, valid_session
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET edit" do
    context "user has admin privileges" do
      it "assigns the requested admin as @admin" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, username: "loggedinuser"))
        admin = User.create! valid_attributes
        get :edit, {:id => admin.to_param}, valid_session
        assigns(:admin).should eq(admin)
      end
    end
    context "user does not have admin privileges" do
      it "returns an error" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter, username: "loggedinuser"))
        admin = User.create! valid_attributes
        get :edit, {:id => admin.to_param}, valid_session
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET main" do
    before do
      @most_recent_questions = [Question.new]
      Question.stub(:recent_questions).and_return(@most_recent_questions)
      @most_recent_answers = [Answer.new]
      Answer.stub(:recent_answers).and_return(@most_recent_answers)
      @most_recent_updates = @most_recent_answers
      Answer.stub(:recent_updates).and_return(@most_recent_updates)
      @most_recent_questions_with_updated_tags = [Question.new]
      Question.stub(:recent_questions_with_updated_tags).and_return(@most_recent_questions_with_updated_tags)
      @most_recent_questions_with_updated_notes = @most_recent_questions_with_updated_tags
      Question.stub(:recent_questions_with_updated_notes).and_return(@most_recent_questions_with_updated_notes)
      @voting_round = [VotingRound.new]
      VotingRound.stub(:where).and_return(@voting_round)
    end

    it "assigns most recent questions as @recent_questions" do
      get :main, {}, valid_session
      assigns(:recent_questions).should eq @most_recent_questions
    end

    it "assigns most recently updated answers as @recent_answers" do
      get :main, {}, valid_session
      assigns(:recent_answers).should eq @most_recent_answers
    end

    it "assigns most recent updates as @recent_updates" do
      get :main, {}, valid_session
      assigns(:recent_updates).should eq @most_recent_updates
    end

    it "assigns most recent tags as @recent_questions_with_updated_tags" do
      get :main, {}, valid_session
      assigns(:recent_questions_with_updated_tags).should eq @most_recent_questions_with_updated_tags
    end

    it "assigns most recent notes as @recent_questions_with_updated_notes" do
      get :main, {}, valid_session
      assigns(:recent_questions_with_updated_tags).should eq @most_recent_questions_with_updated_notes
    end

    it "assigns current voting round as @voting_round" do
      get :main, {}, valid_session
      assigns(:voting_round).should eq @voting_round[0]
    end

  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin" do
        expect {
          post :create, {:admin => valid_attributes}, valid_session
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created admin as @admin" do
        post :create, {:admin => valid_attributes}, valid_session
        assigns(:admin).should be_a(User)
        assigns(:admin).should be_persisted
      end

      it "redirects to the created admin" do
        post :create, {:admin => valid_attributes}, valid_session
        response.should redirect_to(admin_users_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin as @admin" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:admin => { "username" => "invalid value" }}, valid_session
        assigns(:admin).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:admin => { "username" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin" do
        admin = User.create! valid_attributes
        # Assuming there are no other admins in the database, this
        # specifies that the Admin created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update).with({ "username" => "MyString" })
        put :update, {:id => admin.to_param, :admin => { "username" => "MyString" }}, valid_session
      end

      it "assigns the requested admin as @admin" do
        admin = User.create! valid_attributes
        put :update, {:id => admin.to_param, :admin => valid_attributes}, valid_session
        assigns(:admin).should eq(admin)
      end

      it "redirects to the admin" do
        admin = User.create! valid_attributes
        put :update, {:id => admin.to_param, :admin => valid_attributes}, valid_session
        response.should redirect_to(admin_users_url)
      end
    end

    describe "with invalid params" do
      it "assigns the admin as @admin" do
        admin = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => admin.to_param, :admin => { "username" => "invalid value" }}, valid_session
        assigns(:admin).should eq(admin)
      end

      it "re-renders the 'edit' template" do
        admin = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => admin.to_param, :admin => { "username" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    context "when user is an admin" do
      it "destroys the requested admin" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, username: "loggedinuser"))
        admin = User.create! valid_attributes
        expect {
          delete :destroy, {:id => admin.to_param}, valid_session
        }.to change(User, :count).by(-1)
      end

      it "redirects to the admins list" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, username: "loggedinuser"))
        admin = User.create! valid_attributes
        delete :destroy, {:id => admin.to_param}, valid_session
        response.should redirect_to(admin_users_url)
      end
    end
    context "when user is not an admin" do
      it "returns an error" do
        subject.stub(:current_admin).and_return(FactoryGirl.create(:user, :reporter, username: "loggedinuser"))
        admin = User.create! valid_attributes
        delete :destroy, {:id => admin.to_param}, valid_session
        expect(response.status).to eq 401
      end
    end
  end
end

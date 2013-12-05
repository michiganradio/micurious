=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'spec_helper'

describe User do

  before do
    @admin = User.create(username: "user", password: "password", password_confirmation: "password")
  end

  subject{ @admin }

  it { should respond_to(:username) }

  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  its(:remember_token) { should_not be_blank }

  describe "return value of authenticate method" do
    before { @admin.save }
    let(:found_admin) { User.find_by(username: @admin.username) }

    context "with valid password" do
      it { should eq found_admin.authenticate(@admin.password) }
    end

    context "with invalid password" do
      it { should_not eq found_admin.authenticate("invalid password") }
    end
  end

  describe "creation of user" do
    context "when a user with the same username already exists" do
      before do
        @admin.save
        @admin2 = User.create(username: "user1", password: "password", password_confirmation: "password")
        @admin2.username = "user"
      end
      it "is not valid" do
        @admin2.should_not be_valid
      end
    end
  end
end

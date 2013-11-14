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

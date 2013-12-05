require 'features/features_spec_helper'

describe "create user" do
  before do
    signin_as_admin
    @admin_create = Admin::NewUser.new
    @admin_create.load
    @admin_create.username_field.set("rebecca")
    @admin_create.password_field.set("password")
    @admin_create.confirmation_field.set("password")
  end

  context "user being created is an admin" do
    it "is a user with admin privileges" do
      @admin_create.admin_field.set(true)
      @admin_create.create_user_button.click
      @admin_index_page = Admin::Users.new
      @admin_index_page.load
      @admin_index_page.users[1].should have_content("rebecca")
      @admin_index_page.users[1].should have_content("true")
    end
  end

  context "user being created is a reporter" do
    it "is a user without admin privileges" do
      @admin_create.admin_field.set(false)
      @admin_create.create_user_button.click
      @admin_index_page = Admin::Users.new
      @admin_index_page.load
      @admin_index_page.users[1].should have_content("rebecca")
      @admin_index_page.users[1].should have_content("false")
    end
  end
end

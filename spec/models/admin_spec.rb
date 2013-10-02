require 'spec_helper'

describe Admin do
  
  before do
    @admin = Admin.create(username: "user", password: "pw")
  end

  subject{ @admin }

  context "username" do
    it { should respond_to(:username) }
  end

  context "password" do
    it { should respond_to(:password) }
  end
end

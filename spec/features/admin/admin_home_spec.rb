require 'spec_helper'

describe "Admin main" do

  before { visit admin_main_path }
  subject { page }

  describe "links to voting round" do
    it { should have_link('New voting round', href: new_admin_voting_round_path)}
  end
end

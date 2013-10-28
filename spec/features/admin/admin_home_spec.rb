require 'features/features_spec_helper'

describe "Admin main" do
  subject { page }

  before do
    signin_as_admin
    visit admin_path
  end

  describe "links to voting round" do
    it { should have_link('New voting round', href: new_admin_voting_round_path)}
  end
end

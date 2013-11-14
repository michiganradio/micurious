require 'features/features_spec_helper'

describe "/main" do
  subject { page }

  before do
    signin_as_admin
    visit admin_path
  end

  it { should have_link('New voting round', href: new_admin_voting_round_path) }
end

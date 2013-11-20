class Admin::NewVotingRound < SitePrism::Page
  set_url "/admin/voting_rounds/new"
  element :public_label, "#voting_round_public_label"
  element :create_button, "input[value='Create Voting round']"
end

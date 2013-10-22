class Admin::EditVotingRound < SitePrism::Page
  set_url "/admin/voting_rounds/{/id}/edit"
  element :label, "#voting_round_label"
  element :update_button, "input[value='Update Voting round']"
end

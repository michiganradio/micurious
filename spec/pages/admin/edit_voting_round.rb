class Admin::EditVotingRound < SitePrism::Page
  set_url "/admin/voting_rounds/{/id}/edit"
  element :public_label, "#voting_round_public_label"
  element :update_button, "input[value='Update Voting round']"
  element :status_dropdown, "select[id='voting_round_status']"
end

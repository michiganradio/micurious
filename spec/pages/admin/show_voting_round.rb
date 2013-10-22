class Admin::ShowVotingRound < SitePrism::Page
  set_url "/admin/voting_rounds/{/id}"
  element :label, "#voting-round-label"
end

class Admin::VotingRounds < SitePrism::Page
  set_url "/admin/voting_rounds/"
  element :new_voting_round_button, "#new-voting-round-btn"
  elements :rows, "tr[id] > .public-label-display"

  def has_public_label? matching_exp
    match_arr = rows.map { |row| row.text =~ matching_exp }
    match_arr.any?
  end
end

class Admin::VotingRounds < SitePrism::Page
  set_url "/admin/voting_rounds/"
  elements :rows, "tr[id] > .label-display"

  def has_label? matching_exp
    match_arr = rows.map { |row| row.text =~ matching_exp }
    match_arr.any?
  end
end

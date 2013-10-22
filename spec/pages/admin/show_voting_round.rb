class Admin::ShowVotingRound < SitePrism::Page
  set_url "/admin/voting_rounds/{/id}"
  element :label, "#voting-round-label"
  elements :questions, ".question-display-text"

  def has_question? matching_exp
    match_arr = questions.map { |question| question.text =~ matching_exp }
    match_arr.any?
  end
end

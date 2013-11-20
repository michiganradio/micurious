require 'admin/question_section'

class Admin::ShowVotingRound < SitePrism::Page
  set_url "/admin/voting_rounds/{/id}"
  element :public_label, "#voting-round-public-label"
  element :remove_question_confirmation, ".alert-notice"
  sections :questions, Admin::QuestionSection, ".voting-round-question"

  def has_question? matching_exp
    match_arr = questions.map { |question| question.text =~ matching_exp }
    match_arr.any?
  end

  def question_remove_links
    questions.map { |q| q.remove }
  end
end

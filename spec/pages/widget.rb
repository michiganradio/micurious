class VotingWidget < SitePrism::Page
  set_url "/voting_widget"
  set_url_matcher /\/voting_widget/
  elements :questions, "div .widget-question"
  element :widget_prompt, ".widget-prompt"
  elements :vote_buttons, "a.vote"

  def has_number_of_questions? size_to_expect
    questions.size == size_to_expect
  end
end

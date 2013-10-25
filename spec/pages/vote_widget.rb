class VoteWidget < SitePrism::Page
  set_url "/vote_widget"
  set_url_matcher /\/vote_widget/
  elements :questions, "div .widget-question"
  element :widget_prompt, ".widget-prompt"
  elements :vote_buttons, "a.vote"

  def has_number_of_questions? size_to_expect
    questions.size == size_to_expect
  end
end

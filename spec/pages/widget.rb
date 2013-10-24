class Widget < SitePrism::Page
  set_url "/widget"
  set_url_matcher /\/widget/
  elements :questions, "div .widget-question"
  element :widget_prompt, ".widget-prompt"
  elements :vote_buttons, "a.vote"

  def has_number_of_questions? size_to_expect
    questions.size == size_to_expect
  end
end

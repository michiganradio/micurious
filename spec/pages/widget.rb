class Widget < SitePrism::Page
  set_url "/widget"
  elements :questions, "div .question"
  element :widget_prompt, ".widget-prompt"

  def has_number_of_questions? size_to_expect
    questions.size == size_to_expect
  end
end

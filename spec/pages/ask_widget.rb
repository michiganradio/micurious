class AskWidget < SitePrism::Page
  set_url "/ask_widget"
  element :submit_question_text, ".submit-question-text"
  element :submit_button, "input[value='Submit']"
  element :answers_link, "#browse-answers-link"
  element :questions_link, "#browse-questions-link"
end

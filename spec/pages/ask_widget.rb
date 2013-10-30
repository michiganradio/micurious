class AskWidget < SitePrism::Page
  set_url "/ask_widget"
  element :submit_question_text, ".submit-question-text"
  element :submit_button, "input[value='Submit']"
end

class Admin::NewAnswer < SitePrism::Page
  set_url "/admin/answers/new"
  set_url_matcher /\/admin\/answers\/new/

  element :answer_url_field, "#answer_url"
  element :answer_label_field, "#answer_label"
  element :add_answer_button, "input[value='Add answer to question']"
  element :answer_type_answer_radio_button, "input#answer_type_answer"
  element :answer_type_update_radio_button, "input#answer_type_update"
  elements :add_answer_to_question_errors, ".error-message"
end

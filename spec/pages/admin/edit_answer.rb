class Admin::EditAnswer < SitePrism::Page
  set_url "/admin/answers{/answer_id}/edit"

  element :answer_url_field, "#answer_url"
  element :answer_label_field, "#answer_label"
  element :update_answer_button, "input[value='Update Answer']"
  elements :add_answer_to_question_errors, ".error-message"
end

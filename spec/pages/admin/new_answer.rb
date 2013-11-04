class Admin::NewAnswer < SitePrism::Page
  set_url "/admin/answers/new"
  set_url_matcher /\/admin\/answers\/new/

  element :answer_url_field, "#answer_url"
  element :answer_label_field, "#answer_label"
  element :add_answer_button, "input[value='Add answer to question']"
end

class Admin::Answers < SitePrism::Page
  set_url "/admin/answers{?question_id*}"
  elements :answer_urls, ".answer-url"
  elements :answer_labels, ".answer-label"
  elements :answer_types, ".answer-type"
end

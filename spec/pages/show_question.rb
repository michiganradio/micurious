class ShowQuestion < SitePrism::Page
  set_url  "/questions{/question_id}"
  set_url_matcher /\/questions\/\d+/
  elements :question, ".question"
end

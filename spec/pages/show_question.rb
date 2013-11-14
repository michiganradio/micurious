class ShowQuestion < SitePrism::Page
  set_url  "/questions{/question_id}"
  set_url_matcher /\/questions\/\d+/
  element :question_image, ".question-image img"
  element :attribution_link, ".question-image .image-credits a"
  element :checkmark, ".checkmark"
  elements :answer_links, "a.answer-link"
  elements :update_links, "a.update-link"
end

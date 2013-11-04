class ShowQuestion < SitePrism::Page
  set_url  "/questions{/question_id}"
  set_url_matcher /\/questions\/\d+/
  element :question, ".question"
  element :image, ".question img"
  element :attribution_link, ".question-image .image-credits a"
  element :checkmark, "img .checkmark"
end

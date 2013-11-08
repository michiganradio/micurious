class Questions < SitePrism::Page
  set_url  "/questions{/status}{/category_name}"
  elements :question_images, ".question-image img"
  elements :question_image_attribution_links, ".question-image .image-credits a"
  elements :question_links, ".question-link"
end

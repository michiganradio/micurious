class Questions < SitePrism::Page
  set_url  "/questions/categories{/category_name}"
  elements :question_images, ".question-image img"
  elements :question_links, ".question-link"
end

class Questions < SitePrism::Page
  set_url  "/questions{/category_name}"
  elements :questions, ".question"
end

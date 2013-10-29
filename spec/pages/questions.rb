class Questions < SitePrism::Page
  set_url  "/questions/categories{/category_name}"
  elements :questions, ".question"
end

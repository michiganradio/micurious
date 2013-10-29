class Questions < SitePrism::Page
  set_url "/questions{?category_id}"
  elements :questions, ".question"
end

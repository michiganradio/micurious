class Admin::ShowQuestion < SitePrism::Page
  set_url "/admin/questions/{/id}"
  set_url_matcher /\/admin\/questions\/\d+/

  elements :answer_urls, ".answer_url"
  elements :answer_labels, ".answer_label"
end

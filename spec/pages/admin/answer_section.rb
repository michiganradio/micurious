class Admin::AnswerSection < SitePrism::Section
  element :url, ".answer-url"
  element :label, ".answer-label"
  element :type, ".answer-type"
  element :edit_link, ".answer-edit-link"
end

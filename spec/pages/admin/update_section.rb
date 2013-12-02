class Admin::UpdateSection < SitePrism::Section
  element :url, ".update-url"
  element :label, ".update-label"
  element :type, ".update-type"
  element :edit_link, ".update-edit-link"
  element :delete_link, ".update-delete-link > a"
end

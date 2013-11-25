class ModalSection < SitePrism::Section
  element :title, ".modal-title"
  element :body, ".modal-body"
  element :footer, ".modal-footer"
end

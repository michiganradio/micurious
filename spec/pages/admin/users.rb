class Admin::Users < SitePrism::Page
  set_url "/admin/users"

  elements :users, ".user-row"
end

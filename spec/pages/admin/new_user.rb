class Admin::NewUser < SitePrism::Page
  set_url "/admin/users/new"

  element :username_field, "#admin_username"
  element :password_field, "#admin_password"
  element :confirmation_field, "#admin_password_confirmation"
  element :admin_field, "#admin_admin"
  element :create_user_button, "input[value='Create User']"

end

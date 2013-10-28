class Admin::Signin < SitePrism::Page
  set_url "/admin/signin"
  element :username, "#session_username"
  element :password, "#session_password"
  element :signin_button, "input[value='Sign in']"
end

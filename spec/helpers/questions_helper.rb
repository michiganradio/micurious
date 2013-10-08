def sign_in(admin)
  remember_token = Admin.new_remember_token
  cookies[:remember_token] = remember_token
  admin.update_attribute(:remember_token, Admin.encrypt(remember_token))
end

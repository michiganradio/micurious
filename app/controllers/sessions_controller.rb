class SessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin.find_by(username: params[:session][:username].downcase)
    if admin && admin.authenticate(params[:session][:password])
      sign_in admin
      redirect_to admin
    else
      flash.now[:error] = 'Invalid username/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
  end
end

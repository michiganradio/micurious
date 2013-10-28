module Admin
  class SessionsController < Admin::AdminController
    skip_before_action :signed_in_admin
    def new

    end

    def create
      admin = User.find_by(username: params[:session][:username].downcase)
      if admin && admin.authenticate(params[:session][:password])
        sign_in admin
        redirect_to admin_main_path
      else
        flash.now[:error] = 'Invalid username/password combination'
        render 'new'
      end
    end

    def destroy
    end
  end
end

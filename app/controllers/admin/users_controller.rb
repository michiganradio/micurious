=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
module Admin
  class UsersController < Admin::AdminController
    before_action :set_admin, only: [:show, :edit, :update, :destroy]
    before_action :load_page_info, only: [:main]
    before_action :admin_privilege_check, only: [:new, :edit, :destroy]

    # GET /admins
    def index
      @admins = User.all
    end

    # GET /admins/1
    def show
    end

    # GET /admins/new
    def new
      @admin = User.new
    end

    # GET /admins/1/edit
    def edit
    end

    # GET /admin_main
    def main
    end

    # POST /admins
    def create
      @admin = User.new(admin_params)

      respond_to do |format|
        if @admin.save
          format.html { redirect_to admin_users_url, notice: 'User was successfully created.' }
        else
          format.html { render action: 'new' }
        end
      end
    end

    # PATCH/PUT /admins/1
    def update
      respond_to do |format|
        if @admin.update(admin_params)
          format.html { redirect_to admin_users_url, notice: 'User was successfully updated.' }
        else
          format.html { render action: 'edit' }
        end
      end
    end

    # DELETE /admins/1
    def destroy
      @admin.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_url }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_admin
        @admin = User.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def admin_params
        params.require(:admin).permit(:username, :password, :password_confirmation, :admin)
      end

      def load_page_info
        @recent_questions =  Question.recent_questions
        @recent_answers = Answer.recent_answers
        @recent_updates = Answer.recent_updates
        @recent_questions_with_updated_tags = Question.recent_questions_with_updated_tags
        @recent_questions_with_updated_notes = Question.recent_questions_with_updated_notes
        @voting_round = VotingRound.where(status: VotingRound::Status::Live).first
      end
  end
end

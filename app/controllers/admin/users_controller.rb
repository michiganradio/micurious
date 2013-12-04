module Admin
  class UsersController < Admin::AdminController
    before_action :set_admin, only: [:show, :edit, :update, :destroy]
    before_action :load_page_info, only: [:main, :search]

    # GET /admins
    def index
      @admins = User.all
    end

    # GET /admins/1
    def show
    end

    # GET /admins/new
    def new
      if admin_privilege_check
        @admin = User.new
      end
    end

    # GET /admins/1/edit
    def edit
      admin_privilege_check
    end

    # GET /admin_main
    def main
    end

    # POST /admin/search
    def search
      @search_results = Question.with_search_text(params[:text].strip, params[:category])
      render 'main'
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
      if admin_privilege_check
        @admin.destroy
        respond_to do |format|
          format.html { redirect_to admin_users_url }
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_admin
        @admin = User.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def admin_params
        params.require(:admin).permit(:username, :password, :password_confirmation)
      end

      def load_page_info
        @recent_questions =  Question.recent_questions
        @recent_answers = Answer.recent_answers
        @recent_updates = Answer.recent_updates
        @recent_questions_with_updated_tags = Question.recent_questions_with_updated_tags
        @recent_questions_with_updated_notes = Question.recent_questions_with_updated_notes
        @voting_round = VotingRound.where(status: VotingRound::Status::Live).first
        @categories = Category.all
      end
  end
end

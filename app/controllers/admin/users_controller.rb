module Admin
  class UsersController < Admin::AdminController
    before_action :set_admin, only: [:show, :edit, :update, :destroy]


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
      @recent_questions = Question.order(updated_at: :desc).limit(10)
      @recent_answers = Answer.where(type: "Answer").order(updated_at: :desc).limit(10)
      @recent_updates = Answer.where(type: "Update").order(updated_at: :desc).limit(10)
      @recent_questions_with_updated_tags = Question.order(tags_updated_at: :desc).where("tags <> ''").limit(10)
      @recent_questions_with_updated_notes = Question.order(notes_updated_at: :desc).where("notes <> ''").limit(10)
      @voting_round = VotingRound.where(status: VotingRound::Status::Live).first
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
        params.require(:admin).permit(:username, :password, :password_confirmation)
      end
  end
end

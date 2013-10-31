module Admin
  class QuestionsController < Admin::AdminController

    before_action :set_question, only: [:show, :edit, :update, :deactivate, :add_question_to_voting_round]
    before_action :load_categories, only: [:new, :edit]
    before_action :load_voting_rounds, only: [:edit]

    # GET /questions
    def index
      @questions = Question.order("created_at DESC")
    end

    # GET /questions/1
    def show
    end

    # GET /questions/new
    def new
      @question = Question.new
      @question.display_text = params["question"]["text"] if params["question"]
    end

    # GET /questions/1/edit
    def edit
    end

    # POST /questions
    def create
      @question = Question.new(question_params)

      respond_to do |format|
        if @question.save
          format.html { redirect_to admin_question_url(@question), notice: 'Question was successfully created.' }
        else
          load_categories
          format.html { render action: 'new' }
        end
      end
    end

    # PATCH/PUT /questions/1
    def update
      respond_to do |format|
        if @question.update(question_params)
          format.html { redirect_to admin_question_url(@question), notice: 'Question was successfully updated.' }
        else
          load_categories
          load_voting_rounds
          format.html { render action: 'edit' }
        end
      end
    end

    # POST /questions/0
    def deactivate
      if @question.in_active_voting_rounds?
        redirect_to admin_questions_url, flash: { error: "Can not deactivate the question when it's in acitve(new, live) voting rounds"}
      else
        @question.update_attribute(:active, false)
        redirect_to admin_questions_url
      end
    end

    def add_question_to_voting_round
      raise "Please select a voting round to add" unless params[:voting_round_id].present?
      voting_round = VotingRound.find(params[:voting_round_id])
      raise "No voting round exists!" unless voting_round

      if (@question.active)
        voting_round.add_question(@question)
        voting_round.save!
        flash.now[:notice] = 'Question was successfully added to the voting round'
      else
        flash.now[:error] = 'Deactivated question can not be added to voting round'
      end

      @questions = Question.all
      render 'index'
    rescue Exception => error
        redirect_to edit_admin_question_url(@question), flash: {error: error.message}
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_question
        @question = Question.find(params[:id])
      end


      # Never trust parameters from the scary internet, only allow the white list through.
      def question_params
        params.require(:question).permit(:original_text, :display_text, :name, :anonymous, :email,
                                         :email_confirmation, :neighbourhood, :picture_url, :category_ids => [])
      end

      def load_categories
        @categories = Category.all
      end

      def load_voting_rounds
        @voting_rounds = VotingRound.where(status: VotingRound::Status::New)
      end
  end
end

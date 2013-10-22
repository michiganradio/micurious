module Admin
  class QuestionsController < ApplicationController
    before_action :set_question, only: [:show, :edit, :update, :deactivate]
    before_action :signed_in_admin, only: [:index]
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
          format.html { render action: 'edit' }
        end
      end
    end

    # DELETE /questions/0
    def deactivate
      @question.update_attribute(:active, false)
      respond_to do |format|
        format.html { redirect_to admin_questions_url }
      end
    end

    def add_question_to_voting_round
      voting_round = VotingRound.find(params[:voting_round_id])
      raise "No voting round exists!" unless voting_round
      question = Question.find(params[:id])

      if (question.active)
        voting_round.add_question(question)
        voting_round.save!
        flash.now[:notice] = 'Question was successfully added to the voting round'
      else
        flash.now[:error] = 'Deactivated question can not be added to voting round'
      end

      @questions = Question.all
      render 'index'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_question
        @question = Question.find(params[:id])
      end

      def signed_in_admin
         redirect_to admin_signin_path, notice: "Please sign in." unless signed_in?
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def question_params
        params.require(:question).permit(:original_text, :display_text, :name, :anonymous, :email, :neighbourhood, :category_ids => [])
      end

      def load_categories
        @categories = Category.all
      end

      def load_voting_rounds
        @voting_rounds = VotingRound.all
      end
  end
end

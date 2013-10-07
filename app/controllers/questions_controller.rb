class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :deactivate]

  # GET /questions
  def index
    @questions = Question.all
  end

  # GET /questions/1
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /questions/1
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /questions/0
  def deactivate
    @question.update_attribute(:active, false)
    respond_to do |format|
      format.html { redirect_to questions_url }
    end
  end

  def add_question_to_voting_round
    voting_round = VotingRound.last
    raise "No voting round exists!" unless voting_round
    question = Question.find(params[:id])
    voting_round.add_question(question)
    voting_round.save!
    @questions = Question.all
    flash.now[:notice] = "Question was successfully added to the voting round."
    render 'index'
  end

  def ask_question
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:original_text, :display_text)
    end
end

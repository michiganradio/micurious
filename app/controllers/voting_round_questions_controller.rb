class VotingRoundQuestionsController < ApplicationController
  before_action :set_voting_round_question, only: [:show, :edit, :update, :destroy]

  # GET /voting_round_questions
  def index
    @voting_round_questions = VotingRoundQuestion.all
  end

  # GET /voting_round_questions/1
  def show
  end

  # GET /voting_round_questions/new
  def new
    @voting_round_question = VotingRoundQuestion.new
  end

  # GET /voting_round_questions/1/edit
  def edit
  end

  # POST /voting_round_questions
  def create
    @voting_round_question = VotingRoundQuestion.new(voting_round_question_params)

    respond_to do |format|
      if @voting_round_question.save
        format.html { redirect_to @voting_round_question, notice: 'Voting round question was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /voting_round_questions/1
  def update
    respond_to do |format|
      if @voting_round_question.update(voting_round_question_params)
        format.html { redirect_to @voting_round_question, notice: 'Voting round question was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /voting_round_questions/1
  def destroy
    @voting_round_question.destroy
    respond_to do |format|
      format.html { redirect_to voting_round_questions_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_voting_round_question
      @voting_round_question = VotingRoundQuestion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voting_round_question_params
      params.require(:voting_round_question).permit(:voting_round_id, :question_id, :vote_number)
    end
end

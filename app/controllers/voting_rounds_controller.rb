class VotingRoundsController < ApplicationController
  before_action :set_voting_round, only: [:show, :edit, :update, :destroy]

  # GET /voting_rounds
  def index
    @voting_rounds = VotingRound.all
  end

  # GET /voting_rounds/1
  def show
  end

  # GET /voting_rounds/new
  def new
    @voting_round = VotingRound.new
  end

  # GET /voting_rounds/1/edit
  def edit
  end

  # POST /voting_rounds
  def create
    @voting_round = VotingRound.new(voting_round_params)

    respond_to do |format|
      if @voting_round.save
        format.html { redirect_to @voting_round, notice: 'Voting round was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /voting_rounds/1
  def update
    respond_to do |format|
      if @voting_round.update(voting_round_params)
        format.html { redirect_to @voting_round, notice: 'Voting round was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /voting_rounds/1
  def destroy
    @voting_round.destroy
    respond_to do |format|
      format.html { redirect_to voting_rounds_url }
    end
  end

  def add_question
    VotingRoundQuestion.create(voting_round_id: VotingRound.find(params[:id]).id, question_id: params[:question_id])
    render :action => :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_voting_round
      @voting_round = VotingRound.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voting_round_params
      params.require(:voting_round).permit(:start_time, :end_time, :question_id)
    end
end

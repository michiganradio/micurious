class VotingRoundsController < ApplicationController
  before_action :set_voting_round, only: [:show, :edit, :update, :destroy]

  # GET /voting_rounds
  # GET /voting_rounds.json
  def index
    @voting_rounds = VotingRound.all
  end

  # GET /voting_rounds/1
  # GET /voting_rounds/1.json
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
  # POST /voting_rounds.json
  def create
    @voting_round = VotingRound.new(voting_round_params)

    respond_to do |format|
      if @voting_round.save
        format.html { redirect_to @voting_round, notice: 'Voting round was successfully created.' }
        format.json { render action: 'show', status: :created, location: @voting_round }
      else
        format.html { render action: 'new' }
        format.json { render json: @voting_round.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /voting_rounds/1
  # PATCH/PUT /voting_rounds/1.json
  def update
    respond_to do |format|
      if @voting_round.update(voting_round_params)
        format.html { redirect_to @voting_round, notice: 'Voting round was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @voting_round.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /voting_rounds/1
  # DELETE /voting_rounds/1.json
  def destroy
    @voting_round.destroy
    respond_to do |format|
      format.html { redirect_to voting_rounds_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_voting_round
      @voting_round = VotingRound.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def voting_round_params
      params.require(:voting_round).permit(:start_time, :end_time)
    end
end

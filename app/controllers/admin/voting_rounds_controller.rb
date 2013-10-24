module Admin
  class VotingRoundsController < ApplicationController
    before_action :set_voting_round, only: [:show, :edit, :update, :destroy, :remove_question]

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
          format.html { redirect_to admin_voting_rounds_url, notice: 'Voting round was successfully created.' }
        else
          format.html { render action: 'new' }
        end
      end
    end

    # PATCH/PUT /voting_rounds/1
    def update
      @voting_round.update!(voting_round_params)
      redirect_to admin_voting_rounds_url, notice: 'Voting round was successfully updated.'
    rescue
      render action: 'edit'
    end

    def add_question
      VotingRoundQuestion.create(voting_round_id: params[:id], question_id: params[:question_id])
      render :action => :show
    end

    def remove_question
      VotingRoundQuestion.where(voting_round_id: params[:id], question_id: params[:question_id]).first.destroy
      flash.now[:notice] = "Question was successfully removed from the voting round"
      render :show
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_voting_round
        @voting_round = VotingRound.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def voting_round_params
        params.require(:voting_round).permit(:start_time, :end_time, :question_id, :label, :status)
      end
  end
end

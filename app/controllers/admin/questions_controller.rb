=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
module Admin
  class QuestionsController < Admin::AdminController
    before_action :set_question, only: [:show, :edit, :update, :deactivate, :add_question_to_voting_round]
    before_action :load_answers_and_updates, only: [:show]
    before_action :load_voting_rounds, only: [:edit]
    before_action :load_tags, only: [:index, :filter_by_tag]
    before_action :admin_privilege_check, only: [:new, :add_question_to_voting_round]

    # GET /questions
    def index
      @questions = Question.order("created_at DESC")
    end

    # POST /admin/search
    def search
      @search_results = Question.with_search_text(params[:text].strip, params[:category])
    end

    # GET /questions/1
    def show
    end

    # GET /questions/:tag
    def filter_by_tag
        @questions = Question.tagged_with(params[:tag]).order("created_at DESC")
        render 'index'
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
          format.html { render action: 'new' }
        end
      end
    end

    # PATCH/PUT /questions/1
    def update
      if @question.in_active_voting_rounds?
        flash.now[:error] = "Can not update the question when it's in active (new or live) voting rounds"
      elsif @question.update(question_params)
        redirect_to admin_question_url(@question), notice: 'Question was successfully updated.' and return
      end
      load_voting_rounds
      render action: 'edit'
    end

    def add_question_to_voting_round
        raise "Please select a voting round to add" unless params[:voting_round_id].present?
        voting_round = VotingRound.find(params[:voting_round_id])
        raise "No voting round exists!" unless voting_round

        if (@question.active?)
          voting_round.add_question(@question)
          voting_round.save!
          flash.now[:notice] = 'Question was successfully added to the voting round'
        else
          flash.now[:error] = 'A removed question can not be added to voting round'
        end

        load_tags
        @questions = Question.order("created_at DESC")
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
      params.require(:question).permit(:original_text, :display_text, :name, :anonymous, :featured, :email,
                                       :email_confirmation, :neighbourhood, :picture_url, :picture_owner, :picture_attribution_url, :reporter, :status, :notes, :tag_list, :category_ids => [])
    end

    def load_voting_rounds
      @voting_rounds = VotingRound.where(status: VotingRound::Status::New)
    end

    def load_tags
      @tags = Question.tag_counts_on(:tags)
    end

    def load_answers_and_updates
      ordered_answers_both_types = Question.find(params[:id]).answers.order(:position)
      @answers = ordered_answers_both_types.where(type: Answer::Type::Answer)
      @updates = ordered_answers_both_types.where(type: Answer::Type::Update)
    end
  end
end

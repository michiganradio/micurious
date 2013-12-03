module Admin
  class AnswersController < Admin::AdminController
    before_action :load_answers_and_updates, only: [:index, :destroy, :reorder]

    def index
      @question = Question.find(params[:question_id])
    end

    def edit
      if admin_privilege_check
        @answer = Answer.find(params[:id])
      end
    end

    def update
      @answer = Answer.find(params[:id])
      if @answer.update_attributes(answer_params)
        redirect_to(admin_answers_url(question_id: params[:answer][:question_id]))
      else
        render "edit"
      end
    end

    def new
      if admin_privilege_check
        params.require(:question_id)
        @answer = Answer.new
        @answer.question_id = params[:question_id]
      end
    end

    def reorder
      admin_privilege_check
    end

    def sort
      params[:answer].each_with_index do |id, index|
        Answer.find(id).insert_at(index+1)
      end
      render nothing: true
    end

    def create
      @answer = Answer.new(answer_params)
      if @answer.save
        redirect_to(admin_answers_url(question_id: @answer.question_id))
      else
        render "new"
      end
    end

    def destroy
      if admin_privilege_check
        answer = Answer.find(params[:id])
        @question = Question.find(params[:question_id])
        answer.destroy
        render "index"
      end
    end

    private
      def load_answers_and_updates
        params.require(:question_id)
        ordered_answers_both_types = Question.find(params[:question_id]).answers.order(:position)
        @answers = ordered_answers_both_types.where(type: Answer::Type::Answer)
        @updates = ordered_answers_both_types.where(type: Answer::Type::Update)
      end

      def answer_params
        params.require(:answer).permit(:label, :url, :question_id, :type)
      end
  end
end

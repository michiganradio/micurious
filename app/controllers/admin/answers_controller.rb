module Admin
  class AnswersController < Admin::AdminController
    def index
      params.require(:question_id)
      @question = Question.find(params[:question_id])
    end

    def new
      params.require(:question_id)
      @answer = Answer.new
      @answer.question_id = params[:question_id]
    end

    def create
      @answer = Answer.new(answer_params)
      if @answer.save
        redirect_to(admin_question_url(@answer.question_id))
      else
        render "new"
      end
    end

    private
      def answer_params
        params.require(:answer).permit(:label, :url, :question_id, :type)
      end
  end
end

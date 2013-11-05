module Admin
  class AnswersController < Admin::AdminController
    def new
      params.require(:question_id)
      @answer = Answer.new
      @answer.question_id = params[:question_id]
    end

    def create
      @answer = Answer.new(answer_params)
      @answer.save
      redirect_to(admin_question_url(@answer.question_id))
    end

    private
      def answer_params
        params.require(:answer).permit(:label, :url, :question_id, :type)
      end
  end
end

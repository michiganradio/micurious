module Admin
  class AnswersController < Admin::AdminController
    def index
      params.require(:question_id)
      @question = Question.find(params[:question_id])
    end

    def edit
      @answer = Answer.find(params[:id])
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
      params.require(:question_id)
      @answer = Answer.new
      @answer.question_id = params[:question_id]
    end

    def create
      @answer = Answer.new(answer_params)
      if @answer.save
        redirect_to(admin_answers_url(question_id: @answer.question_id))
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

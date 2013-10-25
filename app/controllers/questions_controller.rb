class QuestionsController < ApplicationController
  before_action :set_question, only: [:show]

  def show
    @ask = true
  end

  def new
    @question = Question.new
    @categories = Category.all
    @question.attributes = params.permit(:display_text, :name, :anonymous,
                                         :email, :email_confirmation, :neighbourhood, :category_ids => [])
    respond_to do |format|
      format.js
    end
  end

  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.js { render "received.js.erb" }
      else
        @categories = Category.all
        format.js { render "new.js.erb" }
      end
    end
  end

  def confirm
    @question = Question.new(question_params)
    @categories = Category.all


    respond_to do |format|
      format.js { render @question.valid? ? 'confirm.js.erb' : 'new.js.erb' }
    end
  end

  private
    def question_params
      params.require(:question).permit(:original_text, :display_text, :name, :anonymous, :email, :email_confirmation, :neighbourhood, :category_ids => [] )
    end

    def set_question
      @question = Question.find(params[:id])
    end
end

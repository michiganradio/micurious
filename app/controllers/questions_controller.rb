class QuestionsController < ApplicationController
  before_action :set_question, only: [:show]
  before_action :load_categories, only: [:filter]

  def show
  end

  def filter
    @questions = Question.order("created_at DESC")
    render 'index'
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

  def picture
    @question = Question.new(question_params)
    @categories = Category.all
    respond_to do |format|
      format.js { render @question.valid? ? 'picture.js.erb' : 'new.js.erb' }
    end
  end

  def find_pictures
    @pictures = FlickrService.new.find_pictures params["searchfield"]
    respond_to do |format|
      format.js { render 'find_pictures.js.erb' }
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
      params.require(:question).permit(:searchfield, :original_text, :display_text, :name, :anonymous, :email, :email_confirmation, :neighbourhood, :category_ids => [] )
    end

    def set_question
      @question = Question.find(params[:id])
    end
end

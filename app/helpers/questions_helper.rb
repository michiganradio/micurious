module QuestionsHelper
  def cache_key_for_questions(questions)
    max_updated_at = questions.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "questions-#{params[:status]}-#{params[:category_name]}-#{questions.count}-#{max_updated_at}-#{params[:page]}"
  end
end


module Admin::QuestionsHelper
  def display_tags(question)
    question.tag_list.join(", ")
  end
end

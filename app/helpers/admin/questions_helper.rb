module Admin::QuestionsHelper
  def display_tags(question)
    question.tag_list.join(", ")
  end

  def display_date(date)
    date.strftime("%m/%d/%Y")
  end
end

module ApplicationHelper
  def badge_class question
    return "checkmark" if question.answered?
    return "questionmark" if question.investigating?
  end

  def question_image_url(question)
    question.picture_url.present? ? question.picture_url : image_url("default-question-picture.jpg")
  end

  def question_display_text(question)
   if question.display_text.length <= 140
     question.display_text
   else
     question.display_text[0, 140] << "..."
   end
  end
end

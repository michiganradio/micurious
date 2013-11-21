module ApplicationHelper
  def badge_class question
    return "checkmark" if question.answered?
    return "questionmark" if question.investigating?
  end

  def question_image_url(question)
    question.picture_url.present? ? question.picture_url : image_url(DEFAULT_PICTURE)
  end

  def question_display_text(question)
   if question.display_text.length <= 140
     question.display_text
   else
     question.display_text[0, 140] << "..."
   end
  end

  def anonymity_partial(question)
    question.anonymous? ? "confirm_anonymous" : "confirm_public"
  end

  def smaller_picture(question)
    replace_picture_size(question, "_n.jpg")
  end

  def bigger_picture(question)
    replace_picture_size(question, "_b.jpg")
  end

  private

  def replace_picture_size(question, size_format)
     if question.picture_url.present?
      url = question.picture_url
      url[-6] == "_" ? url.gsub(/_[a-z](.jpg)$/, size_format) : url.gsub(".jpg", size_format)
    else
      DEFAULT_PICTURE
    end
  end

end

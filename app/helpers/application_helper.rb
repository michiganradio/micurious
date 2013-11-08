module ApplicationHelper
  def badge_class question
    return "checkmark" if question.answered?
    return "questionmark" if question.investigating?
  end
end

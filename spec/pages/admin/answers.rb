require 'admin/answer_section'

class Admin::Answers < SitePrism::Page
  set_url "/admin/answers{?question_id*}"
  sections :answers, Admin::AnswerSection, ".answer-row"
end

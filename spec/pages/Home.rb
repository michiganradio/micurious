require 'ask_question_section'
require 'question_received_section'
require 'confirm_question_section'
require 'voting_round_section'

class Home < SitePrism::Page
  set_url "/{#anchor}"

  element :up_for_voting_link, "#up-for-voting-id"
  element :answered_and_investigating_link, "#answered-investigating-id"
  element :new_and_unanswered_link, "#new-unanswered-id"
  element :answered_and_investigation_categories_dropdown, "#answered-investigating ul li"

  element :display_text, "#display_text"
  element :ask_button, "input[value='Ask']"

  section :voting_round, VotingRoundSection, ".voting-round"
  section :ask_question_modal, AskQuestionSection, "#myModal"
  section :confirm_question_modal, ConfirmQuestionSection, "#confirm-question-modal"
  section :question_received_modal, QuestionReceivedSection, "#question-received-modal"
end

=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
require 'ask_question_section'
require 'question_received_section'
require 'confirm_question_section'
require 'voting_round_section'
require 'question_picture_section'

class Home < SitePrism::Page
  set_url "/{#anchor}"
  set_url_matcher /\//

  element :up_for_voting_link, "#up-for-voting-id"
  element :answered_and_investigating_link, "#answered-investigating-id"
  element :new_and_unanswered_link, "#new-unanswered-id"
  element :answered_and_investigation_categories_dropdown, "#answered-investigating ul li"

  element :display_text, "#display_text"
  element :ask_button, "input[value='Ask']"

  section :voting_round, VotingRoundSection, ".voting-round"
  section :ask_question_modal, AskQuestionSection, "#question-modal"
  section :confirm_question_modal, ConfirmQuestionSection, "#confirm-question-modal"
  section :question_received_modal, QuestionReceivedSection, "#question-received-modal"
  section :question_picture_modal, QuestionPictureSection, "#question-picture-modal"
end

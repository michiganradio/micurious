class Home < SitePrism::Page
  set_url "/"

  element :up_for_voting_link, "#up-for-voting-id"
  element :answered_and_investigating_link, "#answered-investigating-id"
  element :new_and_unanswered_link, "#new-unanswered-id"
  element :answered_and_investigation_categories_dropdown, "#answered-investigating ul li"
end

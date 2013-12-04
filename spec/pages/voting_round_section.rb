class VotingRoundSection < SitePrism::Section
  elements :vote_links, ".vote:not(.visible-xs)"
  elements :question_links, "div.question-text > a.question-link"
  elements :picture_links, "span.image-credits > a"
  elements :pictures, "div.question-image img"
  elements :ranks, "h2.rank"
  element :vote_confirm, "div.voted:not(.visible-xs)"
end

class VotingRoundSection < SitePrism::Section
  elements :vote_links, ".vote"
  elements :question_links, "div.question-text > a"
  elements :picture_links, "span.image-credits > a"
  elements :pictures, "div.question-image img"
  elements :ranks, "h2.rank"
  element :vote_confirm, "div.voted"
end

class Question < ActiveRecord::Base
  validates :display_text, length: { maximum: 500 , minimum: 1}
  validates :original_text, length: { maximum: 500, minimum: 1}
end

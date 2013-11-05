class Answer < ActiveRecord::Base
  belongs_to :question

  validates :label, length: { maximum: 255, minimum: 1}
  validates :url, length: { maximum: 255, minimum: 1}
  self.inheritance_column = :_type_disabled
end

class Answer < ActiveRecord::Base
  belongs_to :question

  validates :label, length: { maximum: 255, minimum: 1 }
  validates :url, length: { maximum: 255, minimum: 1 }
  validates :type, presence: true
  self.inheritance_column = :_type_disabled

  module Type
    Answer = "Answer"
    Update = "Update"
    All = [Answer, Update]
  end
end

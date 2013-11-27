class Answer < ActiveRecord::Base
  belongs_to :question

  validates :label, length: { maximum: 3000, minimum: 1 }
  validates :url, length: { maximum: 2000, minimum: 1 }
  validates :type, presence: true
  self.inheritance_column = :_type_disabled

  def self.recent_answers
    where(type: "Answer").order(updated_at: :desc).limit(10)
  end

  def self.recent_updates
    where(type: "Update").order(updated_at: :desc).limit(10)
  end

  module Type
    Answer = "Answer"
    Update = "Update"
    All = [Answer, Update]
  end
end

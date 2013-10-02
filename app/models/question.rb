class Question < ActiveRecord::Base
  attr_readonly :original_text  
  before_create :copy_display_text_into_original_text

  private
    def copy_display_text_into_original_text
      self.original_text = self.display_text
    end

  validates :display_text, length: { maximum: 500 , minimum: 1}
end

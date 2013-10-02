require 'spec_helper'

describe Question do

  before do
    @question = Question.new(original_text: "question original text here",
                              display_text: "question display text here")
  end

  subject{ @question }

  it { should respond_to(:original_text) }
  it { should respond_to(:display_text) }
  it { should ensure_length_of(:original_text).
        is_at_least(1).
        is_at_most(500) }
  
  it { should ensure_length_of(:display_text).
        is_at_least(1). 
        is_at_most(500) }

end

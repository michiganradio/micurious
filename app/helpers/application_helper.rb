=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
module ApplicationHelper
  def badge_class question
    return "checkmark" if question.answered?
    return "questionmark" if question.investigating?
  end

  def question_image_url(question)
    question.picture_url.present? ? question.picture_url : image_url(DEFAULT_PICTURE)
  end

  def question_display_text(question)
   if question.display_text.length <= 140
     question.display_text
   else
     question.display_text[0, 140] << "..."
   end
  end

  def anonymity_partial(question)
    question.anonymous? ? "confirm_anonymous" : "confirm_public"
  end

  def smaller_picture(question)
    replace_picture_size(question, "_n.jpg")
  end

  def bigger_picture(question)
    replace_picture_size(question, "_b.jpg")
  end

  private

  def replace_picture_size(question, size_format)
     if question.picture_url.present?
      url = question.picture_url
      url[-6] == "_" ? url.gsub(/_[a-z](.jpg)$/, size_format) : url.gsub(".jpg", size_format)
    else
      DEFAULT_PICTURE
    end
  end

end

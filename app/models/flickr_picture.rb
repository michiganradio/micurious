=begin
Copyright 2013 WBEZ
This file is part of Curious City.

Curious City is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Curious City is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Curious City.  If not, see <http://www.gnu.org/licenses/>.
=end
class FlickrPicture

  attr_accessor :farm, :server, :picture_id, :secret_key, :width, :height, :owner, :attribution_url

  def initialize(photo)
    self.farm = photo.farm
    self.server = photo.server
    self.picture_id = photo.id
    self.secret_key = photo.secret
    self.owner = photo.owner
    self.attribution_url = "https://www.flickr.com/photos/#{self.owner}/#{self.picture_id}"
  end

  def url
    "http://farm#{farm}.staticflickr.com/#{server}/#{picture_id}_#{secret_key}.jpg"
  end

end

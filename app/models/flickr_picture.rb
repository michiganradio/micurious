class FlickrPicture

  attr_accessor :farm, :server, :picture_id, :secret_key, :width, :height, :owner, :attribution_url

  def initialize(photo)
    self.farm = photo.farm
    self.server = photo.server
    self.picture_id = photo.id
    self.secret_key = photo.secret
    self.width = photo.width
    self.height = photo.height
    self.owner = photo.owner.username
    self.attribution_url = photo.url
  end

  def url
    "http://farm#{farm}.staticflickr.com/#{server}/#{picture_id}_#{secret_key}.jpg"
  end

end

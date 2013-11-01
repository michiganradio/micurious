require 'spec_helper'

describe 'FlickrPicture' do
  before do
    @photo = double(Flickrie::Photo,
                   farm: 4,
                   server: "1234",
                   id: "1234567890",
                   secret: "abcd1234",
                   width: 100,
                   height: 200,
                   owner: double(:owner, username: "owner"),
                   url: "attribution_url")
    @picture = FlickrPicture.new(@photo)
  end

  it "sets the attributes" do
    @picture.farm.should == @photo.farm
    @picture.server.should == @photo.server
    @picture.picture_id.should == @photo.id
    @picture.secret_key.should == @photo.secret
    @picture.width.should == @photo.width
    @picture.height.should == @photo.height
    @picture.owner.should == @photo.owner.username
    @picture.attribution_url.should == @photo.url
  end

  context "url" do
    it "sets the right url from multiple fields" do
      @picture.url.should == "http://farm4.staticflickr.com/1234/1234567890_abcd1234.jpg"
    end
  end
end

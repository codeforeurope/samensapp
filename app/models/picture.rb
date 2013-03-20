class Picture < ActiveRecord::Base
  attr_accessible :attachable_picture_id, :attachable_picture_type, :description, :image

  belongs_to :attachable_picture, polymorphic: true

  mount_uploader :image, ImageUploader

  before_create :default_name

  def default_name
    self.description = File.basename(image.filename, '.*').titleize if image
  end
end

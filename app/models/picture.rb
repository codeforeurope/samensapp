class Picture < ActiveRecord::Base
  attr_accessible :attachable_picture_id, :attachable_picture_type, :description, :image

  belongs_to :attachable_picture, :polymorphic => true

  mount_uploader :image, ImageUploader

end

module ImageModel

  def crop_image
    image.recreate_versions! if crop_x.present?
  end

  MIN_WIDTH = 570
  MIN_HEIGHT = 380

  def validate_minimum_image_size
    unless image.blank?
      if image.file.respond_to?(:sanitize_regexp)
        img = MiniMagick::Image.read(image.file)
      else

        img = MiniMagick::Image.open(image.url)
      end
      unless img[:width] >= MIN_WIDTH && img[:height] >= MIN_HEIGHT
        errors.add :image, :image_minimum_size, :min_width => MIN_WIDTH, :min_height => MIN_HEIGHT
      end
    end
  end
end
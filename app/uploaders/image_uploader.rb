# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MiniMagick
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper
  # Recommended for use with fog
  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}_#{mounted_as}/#{model.id}"
  end

  # # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:

  version :main do
    process :resize_to_fill => [320, 190]
    process :convert => 'jpg'
    def full_filename (for_file = model.image.file)
      "main.jpg"
    end
  end

  version :retina_main do
    process :resize_to_fill => [640, 380]
    process :convert => 'jpg'
    def full_filename (for_file = model.image.file)
      "main@2x.jpg"
    end
  end

  version :thumb, :from_version => :main do
    process :resize_to_fill => [50, 50]
    process :convert => 'jpg'
    def full_filename (for_file = model.image.file)
      "thumb.jpg"
    end
  end

  version :retina_thumb, :from_version => :retina_main do
    process :resize_to_fill => [100, 100]
    process :convert => 'jpg'
    def full_filename (for_file = model.image.file)
      "thumb@2x.jpg"
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png JPG JPEG GIF PNG) if $pass_image
  end

end

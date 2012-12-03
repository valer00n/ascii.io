# encoding: utf-8

class BasicUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    prefix = Rails.env.test? ? '../tmp/' : ''
    prefix + "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  process :bunzip

  def bunzip
    return unless is_bzip2? # https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Do-conditional-processing

    system "bunzip2 #{current_path}"
    File.rename("#{current_path}.out", current_path)
  end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here,
  # see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  private

  def is_bzip2?
    puts 'is_bzip2?'
    mime_type = `file -i -b #{current_path}`
    mime_type =~ %r{application/x-bzip2}
  end

end

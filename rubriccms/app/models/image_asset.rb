class ImageAsset < MediaAsset

  # Behaviours
  # FIXME: Need to take some parameters here.
  has_attached_file :media,
    :styles => {
      :thumbnail => "150x150#"
    },
    :url => "/assets/media/images/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/media/images/:id/:style/:basename.:extension"

  attr_accessor :should_destroy
  before_save :update_name
  
  # Named scopes
  named_scope :find_without_extension, lambda {|filename| {:conditions => ["media_file_name LIKE ?", filename.downcase.gsub(/\.jpg|\.png|\.gif/,'') << '.%']} }

  # Validations
  validates_presence_of :media_file_name
  validates_attachment_size :media, :less_than => SiteConfiguration.maximum_file_size_for_flash_asset.megabytes, :message => "file size cannot exceed #{SiteConfiguration.maximum_file_size_for_flash_asset} MB."
  validates_attachment_content_type :media, :content_type => ['image/jpeg', 'image/png'], :message => 'file must be a valid PNG (.png) or JPEG (.jpg) file.'

  # Methods
  
  def should_destroy? #:nodoc:
    # Needed for removal of image asset from association model form
    self.should_destroy.to_i == 1
  end

  def update_name #:nodoc:
    self.name = self.media_file_name
  end
  
end
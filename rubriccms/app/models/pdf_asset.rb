class PdfAsset < MediaAsset

  # Behaviours
  has_attached_file :media,
    :url => "/assets/media/pdf/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/media/pdf/:id/:style/:basename.:extension",
    :styles => {
      :thumbnail => "150x194>"
    }
    
  # Validations
  validates_presence_of :media_file_name
  validates_attachment_size :media, :less_than => SiteConfiguration.maximum_file_size_for_flash_asset.megabytes, :message => "file size cannot exceed #{SiteConfiguration.maximum_file_size_for_flash_asset} MB."
  validates_attachment_content_type :media, :content_type => ['application/pdf'], :message => 'file must a valid PDF document.'

end
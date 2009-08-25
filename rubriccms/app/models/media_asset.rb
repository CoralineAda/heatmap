class MediaAsset < ActiveRecord::Base

  # Behaviours
  
  # Constants
  FILTERS = [
    {:scope => 'all',       :label => 'All'},
    {:scope => 'images',    :label => 'All Images'},
    {:scope => 'quicktime', :label => 'All Quicktime Movies'},
    {:scope => 'flash',     :label => 'All Flash Files'},
    {:scope => 'pdfs',       :label => 'All PDF Documents'}
  ]

  # Named scopes
  named_scope :all,       :conditions => [ "type IN ('ImageAsset','QuicktimeAsset','FlashAsset','PdfAsset')" ]
  named_scope :images,    :conditions => { :type => 'ImageAsset' }
  named_scope :quicktime, :conditions => { :type => 'QuicktimeAsset' }
  named_scope :flash,     :conditions => { :type => 'FlashAsset' }
  named_scope :pdfs,      :conditions => { :type => 'PdfAsset' }

  # Relationships
  
  # Validations

  # Methods
  
  def image?
    self.class.name == 'ImageAsset'
  end

  def flash?
    self.class.name == 'FlashAsset'
  end

  def pdf?
    self.class.name == 'PdfAsset'
  end

  def quicktime?
    self.class.name == 'QuicktimeAsset'
  end
  
  # URL stripped of ?123456 that Rails suffixes to prevent caching
  def self.canonical_url(url)
    url.gsub(/\?.+/,'')
  end
    
  def media_type
    _t = self.class.name.gsub('Asset','')
    _t.upcase! if _t == 'Pdf'
    _t
  end
  
end
# FIXME: 
# * Add @site_section.sidebar_items.to_hash
class SiteSection < ActiveRecord::Base

  @root_url_has_changed = false
  
  # Callbacks
  before_validation :sanitize_root_url
  before_save :detect_root_url_change
  after_save :update_site_page_urls
  
  # Named scopes
  named_scope :active, :conditions => { :active => true }
  named_scope :with_pages, :conditions => ['site_pages_count > ?', 0]

  # Relationships
  has_many :navbar_items, :dependent => :destroy
  has_many :site_pages, :dependent => :destroy
  has_many :sidebar_items, :dependent => :destroy
  
  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name, :root_url
  
  # Methods

  def detect_root_url_change
    @root_url_has_changed = self.root_url_changed?
    @previous_root_url = self.root_url_was if @root_url_has_changed
  end
  
  def root_page
    root_page = self.site_pages.find_by_url(self.root_url) if self.site_pages
    root_page || nil
  end
  
  def root_page_navbar_link
    return unless self.root_page
    return unless self.root_page.navbar_items
    return self.root_page.navbar_items.roots.first || nil
  end
  
  def sanitize_root_url
    return if root_url == "/"
    self.root_url.downcase!
    self.root_url.gsub!(/[^a-z0-9]/,'_')
    self.root_url.gsub!(/[-]+/,'_')
    self.root_url.gsub!(/^_/,'')
    self.root_url.gsub!(/_$/,'')
    self.root_url = "/#{self.root_url}/"
  end
  
  def update_site_page_urls
    # If the root_url changes, site_pages must have their URLs updated as well
    self.site_pages.each{|sp| sp.update_url(@previous_root_url, self.root_url)} if @root_url_has_changed
  end
  
  def to_hash
    {
      :name => self.name,
      :title => self.name,
      :url => self.root_page.url
    }
  end
  
end

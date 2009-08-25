class SitePage < ActiveRecord::Base

  include AASM
  acts_as_audited

  @url_has_changed = false
  
  # Behaviours
  acts_as_nested_set
  attr_accessor :navbar_item_enabled
  attr_accessor :sidebar_item_enabled
  
  # Callbacks
  before_validation :make_url
  after_save        :update_nav_items
  
  # Constants
  FIELDS_TO_AUDIT = %w{ page_title slug meta_keywords meta_description content }
  
  # Named scopes
  named_scope :published, :conditions => ['state = ?', 'published'], :order => 'url'
  named_scope :drafts,    :conditions => ['state = ?', 'draft'], :order => 'url'
  
  # Relationships
  belongs_to  :site_section, :counter_cache => true
  belongs_to  :user
  has_many    :navbar_items, :dependent => :destroy
  has_many    :sidebar_items, :dependent => :destroy
  has_many    :footer_items, :dependent => :destroy

  # States
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :published

  aasm_event :publish do
    transitions :to => :published, :from => [:draft]
  end

  aasm_event :unpublish do
    transitions :to => :draft, :from => [:published]
  end

  # Validations
  validates_presence_of :page_title, :slug, :site_section
  validates_uniqueness_of :page_title, :url
  
  # Methods
  
  def self.site_root
    SitePage.find_by_home_page_and_state(true, 'published')
  end
  
  def make_url
    # Is this the home page for the site?
    if self.slug == "/" && self.site_section.root_url == "/"
      self.url = "/"
      self.home_page = true
      return
    end
    sanitize_slug
    if self.parent
      # Child page. Currently not used.
      self.url = "#{self.parent.url}#{self.slug}/"
    elsif self.slug == self.site_section.root_url.gsub('/','')
      # Root page for this site section. Slug = root_url of site section
      self.slug = self.site_section.root_url
      self.url = self.site_section.root_url
    else
      # Default: just a page inside the site section.
      self.url = "#{self.site_section.root_url}#{self.slug}/"
    end
    @url_has_changed = self.url_changed? && self.published?
    @previous_root_url = self.url_was if @url_has_changed
    self.url
  end

  def name
    _name = self.read_attribute :name
    _name.blank? ? "[#{self.page_title}]" : _name
  end

  def navbar_item_enabled?
    ! self.navbar_item_enabled.to_i.zero?
  end
  
  def sidebar_item_enabled?
    ! self.sidebar_item_enabled.to_i.zero?
  end
  
  def root_page?
    self.url == self.site_section.root_url || self.home_page?
  end

  # Sets default values if this is the defacto root page for its site section.
  def do_defaults
    return unless self.site_section
    unless self.site_section.root_page
      self.slug = self.site_section.root_url
      self.name = self.site_section.name
      self.page_title = self.site_section.name
    end
  end
  
  # If the url changes, related nav items must have their URLs updated as well
  def update_nav_items

    # Update existing
    (self.navbar_items | self.sidebar_items | self.footer_items).each{ |ni| ni.update_attributes(:url => self.url, :site_section_id => self.site_section_id) }

    # Create if needed    
    if self.published?
      NavbarItem.create_for_page(self) if self.navbar_item_enabled? && self.site_section.navbar_enabled? && self.navbar_items.empty?
      SidebarItem.create_for_page(self) if self.sidebar_item_enabled? && self.site_section.sidebar_enabled? && self.sidebar_items.empty?
    end
    
  end

  def sanitize_slug
    self.slug.downcase!
    self.slug.gsub!(/[^a-z0-9\/]/,'_')
    self.slug.gsub!(/[-]+/,'_')
    self.slug.gsub!(/^-/,'')
    self.slug.gsub!(/-$/,'')
    self.slug.gsub!(/^\//,'')
    self.slug.gsub!(/\/$/,'')
  end
  
  # Determine if this object's URL is up-to-date; update otherwise
  # Called when SiteSection's root URL changes.
  def update_url(old_url, new_url)
    self.slug = new_url if self.url == old_url
    self.save
  end
  
  def updated_by
    return unless self.user
    User.find(self.user) ? User.find(self.user).name : '-'
  end
  
  def status
    self.state.titleize
  end

  def to_hash
    {
      :name => self.name,
      :title => self.name,
      :url => self.url
    }
  end
  
end

class NavbarItem < NavigationItem

  # Behaviours
  acts_as_nested_set
  acts_as_list :column => :position
  
  # Callbacks
  before_validation :determine_url
  
  # Constants
  
  # Named scopes
  named_scope :top_level, :conditions => { :parent_id => nil }, :order => :position
  named_scope :subnav_items_for, lambda {|parent| {:conditions => ['parent_id = ?', parent], :order => :position} }
  
  # Relationships

  # Validations

  # Instance methods

  def sub_nav_items
    NavbarItem.subnav_items_for(self)
  end

  # Class methods
  
  # If the page is a root page, use its site section name as the link text so that the nav menu looks right.
  def self.create_for_page(site_page)
    _n = NavbarItem.create(
      :link_text => site_page.root_page? ? site_page.site_section.name : site_page.page_title,
      :link_title => site_page.page_title,
      :site_section => site_page.site_section,
      :site_page => site_page,
      :url => site_page.url
    )
    unless site_page.root_page? || site_page.site_section.root_page.nil?
      _n.move_to_child_of(site_page.site_section.navbar_items.root)
    end
  end
    
  def enabled?
    self.site_section ? self.site_section.navbar_enabled? : true
  end
  
end
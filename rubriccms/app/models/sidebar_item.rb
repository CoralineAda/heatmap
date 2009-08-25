class SidebarItem < NavigationItem

  # Behaviours
  acts_as_list :column => :position
  
  # Callbacks
  before_validation :determine_url
  
  # Constants
  
  # Named scopes
  named_scope :all, :order => 'position ASC'
  
  # Relationships
  
  # Validations

  # Methods

  def self.create_for_page(site_page)
    return if site_page.root_page? # Don't create a sidebar item for root-level pages in a section
    _n = SidebarItem.create(
      :link_text => site_page.page_title,
      :link_title => site_page.page_title,
      :site_section => site_page.site_section,
      :site_page => site_page,
      :url => site_page.url
    )
  end
  
  def enabled?
    self.site_section.sidebar_enabled?
  end

end
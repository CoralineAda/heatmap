class FooterItem < NavigationItem

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
  
end
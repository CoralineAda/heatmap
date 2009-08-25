class NavigationItem < ActiveRecord::Base

  # Relationships
  belongs_to :site_page
  belongs_to :site_section
  
  # Validations
  validates_presence_of :link_text, :url
  
  # Methods

  # Used in callbacks
  def determine_url
    if self.site_page
      self.url = self.site_page.published? ? self.site_page.url : ''
    else
      self.url = "/#{self.url.gsub(/^\/(.+)\/$/,'\1')}/".gsub(/[\/]+/,'/') unless self.url.include?('http')
    end
  end

  def to_hash
    {
      :name     => self.link_text,
      :title    => self.link_title,
      :url      => self.url,
      :nofollow => self.nofollow?,
      :popup    => self.popup,
      :subnav   => NavbarItem.subnav_items_for(self).map{|i| i.to_hash}.sort{|a,b| a[:position].to_i <=> b[:position].to_i}
    }
  end
  
end

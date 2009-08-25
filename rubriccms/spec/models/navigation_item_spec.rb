require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NavigationItem do

  describe 'correctly determines its URL' do
    
    it 'when it has an associated SitePage'
    
    it 'when it does not have an associated SitePage'
  
  end
  
  describe 'each subclass can be converted to a hash' do
  
    it 'including FooterItem'
    
    it 'including NavbarItem'

    it 'including SidebarItem'

  end
  
end


#   def determine_url
#     if self.site_page
#       self.url = self.site_page.published? ? self.site_page.url : ''
#     else
#       self.url = "/#{self.url.gsub(/^\/(.+)\/$/,'\1')}/".gsub(/[\/]+/,'/') unless self.url.include?('http')
#     end
#   end
# 
#   def to_hash
#     {
#       :name     => self.link_text,
#       :title    => self.link_title,
#       :url      => self.url,
#       :nofollow => self.nofollow?,
#       :subnav   => NavbarItem.subnav_items_for(self).map{|i| i.to_hash}.sort{|a,b| a[:position].to_i <=> b[:position].to_i}
#     }
#   end

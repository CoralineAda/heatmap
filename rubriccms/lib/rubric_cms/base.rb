# Defines the core methods of the RubricCms engine.
#
# Note that methods that are defined here are namespaced, so they are not intended to be overridden in
# the main app. For methods that can be overridden by the main application, refer to 
# RubricCms::RubricCmsHelper in extensions.rb
#
# FIXME Generic breadcrumbs method to generate HTML for breadcrumbs
# FIXME Include a layout file for illustrative purposes?
module RubricCms

  class Site
    
    # Returns the public name of the site. This can be specified in /config/rubric_cms.rb
    # or through the Site Configuration admin interface.
    def self.site_name
      SiteConfiguration.active_configuration.site_name
    end
    
    # Returns the default meta description for the site. This can be specified in /config/rubric_cms.rb
    # or through the Site Configuration admin interface.
    def self.default_meta_description
      SiteConfiguration.active_configuration.default_meta_description
    end
    
    # Returns default meta keywords for the site. These can be specified in /config/rubric_cms.rb
    # or through the Site Configuration admin interface.
    def self.default_meta_keywords
      SiteConfiguration.active_configuration.default_meta_keywords
    end
        
  end
  
  # Flag indicating whether to replace show/edit/delete links with icons in admin views.
  def self.use_crud_icons
    true
  end

end
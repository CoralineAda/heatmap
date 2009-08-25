class RubricCms::SiteMapController < ApplicationController

  def index
    @site_sections = SiteSection.active.with_pages.order_by(:name, 'ASC')    
  end
  
end

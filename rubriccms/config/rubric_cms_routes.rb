ActionController::Routing::Routes.draw do |map|

  # Named routes 
  # =======================================
  
  # Main admin page
  map.rubric_cms_admin '/rubric_cms_admin/', :controller => 'rubric_cms/home', :action => 'index'
  
  # FIXME Namespace this?
  # Side-bar items
  map.reorder_sidebar_items 'sidebar_items/reorder', :controller => 'rubric_cms/sidebar_items', :action => 'reorder'

  # FIXME Namespace this?
  # Site map
  map.site_map '/sitemap.xml', :controller => 'rubric_cms/site_map', :action => 'index', :format => 'xml', :conditions => { :method => :get }
  map.site_map '/sitemap', :controller => 'rubric_cms/site_map', :action => 'index', :conditions => { :method => :get }

  # RESTful routes
  # =======================================

  map.resources :audits,
    :controller => 'rubric_cms/audits'
  map.resources :flash_assets,
    :controller => 'rubric_cms/flash_assets'
  map.resources :footer_items,
    :controller => 'rubric_cms/footer_items',
    :collection => {
      :reorder => :put
    }
  map.resources :image_assets,
    :controller => 'rubric_cms/image_assets',
    :collection => {
      :image_dialog => :get
    }
  map.resources :media_assets,
    :controller => 'rubric_cms/media_assets',
    :collection => {
      :mce_dialog => :get
    }
  map.resources :navbar_items,
    :controller => 'rubric_cms/navbar_items',
    :collection => {
      :reorder => :post
    }
  map.resources :pdf_assets,
    :controller => 'rubric_cms/pdf_assets',
    :collection => {
      :mce_dialog => :get
    }
  map.resources :quicktime_assets,
    :controller => 'rubric_cms/quicktime_assets'
  map.resources :sidebar_items,
    :controller => 'rubric_cms/sidebar_items'
  map.resources :site_configurations,
    :controller => 'rubric_cms/site_configurations'
  map.resources :site_pages,
    :controller => 'rubric_cms/site_pages'
  map.resources :site_sections, :controller => 'rubric_cms/site_sections' do |site_sections|
    site_sections.resources :sidebar_items,  :controller => 'rubric_cms/sidebar_items'
    site_sections.resources :site_pages,     :controller => 'rubric_cms/site_pages'
  end

  # Catch-all route
  # =======================================
  
  # Note: If you have your own catch-all routes in place, you may need to tweak this.
  map.permalink '/*url/', :controller => 'rubric_cms/site_pages', :action => 'show'

end

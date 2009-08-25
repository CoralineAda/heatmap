require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SitePage do

  before do
    @site_section = SiteSection.make(:root_url => '/foo/')
    @unpublished_page = SitePage.make(:page_title => 'Draft title')
    @published_page = SitePage.make(:page_title => 'Initial title')
    @published_page.publish!
  end
  
  describe 'navigation items' do

    describe 'sidebar items' do

      before do
        @ss_without_sidebar = SiteSection.make(:sidebar_enabled => false)
        @ss_with_sidebar = SiteSection.make(:sidebar_enabled => true)
      end
      
      it 'does not create a sidebar item if sidebar_enabled is false' do
        _p = SitePage.make(:site_section => @ss_without_sidebar, :slug => 'tempest_fugit')
        _p.publish!
        _p.sidebar_items.should be_empty
      end
    
      it 'does not create a sidebar item for an unpublished page' do
        _p = SitePage.make(:site_section => @ss_with_sidebar, :slug => 'unusual_doctrines')
        _p.sidebar_items.should be_empty
      end
        
      it 'does not create a sidebar item if the page is a root page' do
        _p = SitePage.make_unsaved(:site_section => @ss_with_sidebar, :slug => @ss_with_sidebar.root_url)
        _p.save
        _p.publish!
        _p.reload.sidebar_items.size.should == 0
      end

      it 'creates a sidebar item if the page is published and sidebar_enabled is true' do
        _p = SitePage.make(:site_section => @ss_with_sidebar, :slug => 'gotta_love_figs')
        _p.publish!
        _p.reload.sidebar_items.should_not be_empty
        _p.sidebar_items.last.site_page.should == _p
      end
      
      it 'defaults link text to the page name for non-root pages' do
        _p1 = SitePage.make(:site_section => @ss_with_sidebar, :slug => 'incredible_value')
        _p1.publish!
        _p2 = SitePage.make(:site_section => @ss_with_sidebar, :slug => 'step_right_up')
        _p2.publish!
        _p2.reload.sidebar_items.last.link_text.should == _p2.page_title
      end

    end
    
    describe 'navbar items' do
    
      before do
        @ss_without_navbar = SiteSection.make(:navbar_enabled => false)
        @ss_with_navbar = SiteSection.make(:navbar_enabled => true)
      end
      
      it 'defaults link text to the site section name for root pages' do
        _p = SitePage.make_unsaved(:site_section => @ss_with_navbar, :slug => @ss_with_navbar.root_url)
        _p.save
        _p.publish!
        _p.root_page?.should be_true
        _p.reload.navbar_items.last.link_text.should == @ss_with_navbar.name
      end

      it 'does not create a top-level navbar item if navbar_enabled is false' do
        _p = SitePage.make(:site_section => @ss_without_navbar, :slug => 'fish_in_the_jailhouse')
        _p.publish!
        _p.navbar_items.should be_empty
      end
    
      it 'does not create a top-level navbar item for an unpublished page' do
        _p = SitePage.make(:site_section => @ss_with_navbar, :slug => 'keyless_window')
        _p.navbar_items.should be_empty
      end
        
      it 'creates a top-level navbar item if the page is published and navbar_enabled is true' do
        _p = SitePage.make(:site_section => @ss_with_navbar, :slug => 'troubles_braids')
        _p.publish!
        _p.reload.navbar_items.should_not be_empty
        _p.navbar_items.last.site_page.should == _p
      end
      
      it 'defaults link text to the page name for non-root pages' do
        _p1 = SitePage.make(:site_section => @ss_with_navbar, :slug => 'bottom_of_the_world')
        _p1.publish!
        _p2 = SitePage.make(:site_section => @ss_with_navbar, :slug => 'railroad_tracks')
        _p2.publish!
        _p2.reload.navbar_items.last.link_text.should == _p2.page_title
      end
      
    end
  
  end
  
  describe 'publishing lifecycle' do

    it 'allows a draft page to be published' do
      @published_page.published?.should be_true
    end
    
    it 'returns the name of the last editor' do
      @author = User.make
      @new_page = SitePage.make(:user => @author)
      @new_page.updated_by.should == @author.name
    end
    
    it 'returns a formatted status' do
      @published_page.status.should == 'Published'
    end
    
    it 'retrieves its last published version' do
      @sp = SitePage.make(:page_title => 'Original Title', :slug => 'i_want_out_of_the_circus')
      @sp.publish!
      @sp.page_title = 'New Title'
      @sp.save
      @sp.page_title.should == 'New Title'
    end
    
  end
    
  describe 'url generation' do
  
    before do
      @published_page.site_section = @site_section
      @published_page.save
    end
  
    it 'generates a url for a child page' do
      @child = SitePage.make(:site_section => @site_section, :slug => 'trouble')
      @child.move_to_child_of(@published_page)
      @child.make_url
      @child.url.should == "/foo/#{@published_page.slug}/trouble/"
    end
    
    it 'generates a url for a site section home page' do
      @published_page.slug = 'foo'
      @published_page.save
      @published_page.url.should == '/foo/'
    end
    
    it 'generates a url for a page within a site section' do
      @published_page.slug = 'bar'
      @published_page.save
      @published_page.url.should == '/foo/bar/'
    end
    
  end
  
  describe 'root page' do
  
    before do
      @new_site_section = SiteSection.make(:root_url => '/heroes/', :name => 'Heroes')
      @root_page = SitePage.make(:slug => '/heroes/', :site_section => @new_site_section)
      @nonroot_page = SitePage.make(:site_section => @new_site_section, :slug => 'elsinor')
    end
    
    it 'identifies root pages' do
      @new_site_section.root_page.should == @root_page
      @root_page.root_page?.should be_true
      @nonroot_page.root_page?.should be_false
    end
    
  end
  
  describe 'home page' do
  
    before do
      @ss = SiteSection.make(:root_url => '/', :name => 'Misc')
      @home_page = SitePage.make(:slug => '/', :site_section => @ss)
      @home_page.publish!
    end
    
    it 'creates a home page for the site' do
      @home_page.url.should == "/"
      @home_page.home_page?.should be_true
    end
  
    it 'identifies the home page for the site' do
      SitePage.site_root.should == @home_page
    end
  
  end

  it 'can be converted to a hash' do
    @new_site_section = SiteSection.make(:root_url => '/goats/', :name => 'All About Goats')
    @hashish = SitePage.make(:name => 'Something', :slug => '/gruff/', :site_section => @new_site_section)
    _to_hash = @hashish.to_hash
    _to_hash.is_a?(Hash).should be_true
    _to_hash[:name].should == @hashish.name
    _to_hash[:title].should == @hashish.name
    _to_hash[:url].should == @hashish.url
  end
    
  
end

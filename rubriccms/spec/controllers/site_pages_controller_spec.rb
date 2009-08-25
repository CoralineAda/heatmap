require File.dirname(__FILE__) + '/../spec_helper'
require 'mir_utility'

include ApplicationHelper
include RubricCms::RubricCmsHelper

describe RubricCms::SitePagesController do

  integrate_views
  
  before do
    @site_section = SiteSection.make
  end
  
  def create_site_page(options = {})
    _ss = SiteSection.make
    _new = SitePage.make_unsaved
    _new.attributes = options
    post :create, :site_page => _new.attributes, :site_section_id => _ss.id
  end
  
  # ============================================ Custom ============================================

  # This has to be tested in a controller instead of the helper's spec, because the get method does
  # not allow you to specify a controller.
  describe RubricCmsHelper do
  
    before do
      @ss = SiteSection.make
      @sp = SitePage.make_unsaved(:site_section => @ss, :slug => @ss.root_url.gsub(/\//,''))
      @sp.save
      @sp.publish!
      @sp.reload
      @subpage = SitePage.make_unsaved(:site_section => @ss, :slug => 'photographic_proof')
      @subpage.save
      @subpage.publish!
      @subpage.reload
    end
    
    it 'correctly identifies a site page' do
      get :show, :id => @sp
      response.should be_success
      viewing_a_site_page?.should be_true
    end

    it 'does not incorrectly identify a site page' do
      login_as_admin
      get :edit, :id => @sp
      response.should be_success
      viewing_a_site_page?.should be_false
    end

    describe 'breadcrumbs' do
    
      it 'returns a breadcrumb for a section home page' do
        @site_page = @ss.root_page
        get :show, :id => @site_page
        breadcrumb_items.should == [{:name => "Home", :url => root_path}, @ss.to_hash]
      end
      
      it 'returns a breadcrumb for a subpage in a section' do
        @site_page = @subpage
        get :show, :id => @site_page
        breadcrumb_items.should == [{:name => "Home", :url => root_path}, @ss.to_hash]
      end

      it 'accepts parameters and constructs an appropriate breadcrumb' do
        _manual = {:name => "Special Page", :url => "/foo"}
        breadcrumb_items(_manual).should == [{:name => "Home", :url => root_path}, _manual]
      end
      
      it 'returns a breadcrumb in HTML format for a site page' do
        @site_page = @ss.root_page
        get :show, :id => @site_page
        _ss = @ss.to_hash
        html_for_breadcrumbs.should == %{<a href="#{root_path}" title="Home">Home</a> &gt; <a href="#{_ss[:url]}" title="#{_ss[:name]}">#{_ss[:name]}</a>}
      end

      it 'accepts paramters and returns an appropriate breadcrumb in HTML format' do
        _manual = {:name => "Special Page", :url => "/foo"}
        html_for_breadcrumbs(_manual).should == %{<a href="#{root_path}" title="Home">Home</a> &gt; <a href="#{_manual[:url]}" title="#{_manual[:name]}">#{_manual[:name]}</a>}
      end
      
    end
    
    it 'returns footer navigation items' do
      FooterItem.destroy_all
      5.times{ |i| FooterItem.make(:position => i) }
      _expected = FooterItem.order_by(:position, 'ASC').map{|f| f.to_hash}
      footer_navigation_items.should == _expected
    end
    
    it 'returns sidebar navigation items' do
      @site_page = @subpage
      _expected = @site_page.sidebar_items.first.to_hash
      sidebar_navigation_items.should == [_expected]
    end
    
    describe 'meta description and meta keywords' do
    
      integrate_views
      
      before do
        @ss = SiteSection.make(:default_meta_description => "This is from the site section.", :default_meta_keywords => ["site", "section", "keywords"])
        @sp = SitePage.make_unsaved(:site_section => @ss, :slug => @ss.root_url.gsub(/\//,''), :meta_description => "This is something for the site page.", :meta_keywords => ["site", "page", "keywords"])
        @sp.save
        @sp.publish!
        @sp.reload
        @defaults = {
          :site => {
            :description => SiteConfiguration.default_meta_description || RubricCms::Config.default_meta_description,
            :keywords => SiteConfiguration.default_meta_keywords || RubricCms::Config.default_meta_keywords
          },
          :site_section => {
            :description => @ss.default_meta_description,
            :keywords => @ss.default_meta_keywords
          },
          :site_page=> {
            :description => @sp.meta_description,
            :keywords => @sp.meta_keywords
          }
        }
      end
      
      it 'returns the meta desc for the site page' do
        @site_page = @sp
        get :show, :id => @site_page.id
        meta_tag_content(:description).should == @defaults[:site_page][:description]
      end

      it 'returns the default meta desc for the section if no meta desc is defined for the page' do
        @sp.update_attribute(:meta_description, nil)
        @site_page = @sp
        get :show, :id => @site_page.id
        meta_tag_content(:description).should == @defaults[:site_section][:description]
      end

      it 'returns the default meta desc for the site if no meta desc is defined for the page or section' do
        @ss.update_attribute(:default_meta_description, nil)
        @sp.update_attribute(:meta_description, nil)
        @site_page = @sp
        get :show, :id => @site_page.id
        meta_tag_content(:description).should == @defaults[:site][:description]
      end

      it 'accepts content as a parameter for meta description' do
        @site_page = @sp
        get :show, :id => @site_page.id
        meta_tag_content(:description, 'Overriding the desc.').should == 'Overriding the desc.'
      end
      
      it 'returns the meta keywords for the site page' do
        @site_page = @sp
        get :show, :id => @site_page.id
        meta_tag_content(:keywords).should == @defaults[:site_page][:keywords]
      end

      it 'returns the default meta keywords for the section if no meta keywords are defined for the page' do
        @sp.update_attribute(:meta_keywords, nil)
        @site_page = @sp
        get :show, :id => @site_page.id
        meta_tag_content(:keywords).should == @defaults[:site_section][:keywords]
      end

      it 'returns the default meta keywords for the site if no meta keywords are defined for the page or section' do
        @ss.update_attribute(:default_meta_keywords, nil)
        @sp.update_attribute(:meta_keywords, nil)
        @site_page = @sp
        get :show, :id => @site_page.id
        meta_tag_content(:keywords).should == @defaults[:site][:keywords]
      end

      it 'accepts array content as a parameter for meta keywords' do
        @site_page = @sp
        get :show, :id => @site_page.id
        meta_tag_content(:keywords, ['overriding','keywords']).should == 'overriding, keywords'
      end
      
      it 'accepts string content as a parameter for meta keywords' do
        @site_page = @sp
        get :show, :id => @site_page.id
        meta_tag_content(:keywords, 'overriding, keywords, again').should == 'overriding, keywords, again'
      end

    end
        
    # FIXME
    describe 'media assets' do
    
      before do
        3.times{ |i| FlashAsset.make(:media_file_name => "flash_#{i}.swf") }
        3.times{ |i| ImageAsset.make(:media_file_name => "image_#{i}.jpg") }
        3.times{ |i| PdfAsset.make(:media_file_name => "pdf_#{i}.pdf") }
        3.times{ |i| QuicktimeAsset.make(:media_file_name => "qt_#{i}.mov") }
        @select = %{<option value="">Select...</option>}
      end
      
      it 'populates options for flash assets' do
        _expected = [@select, FlashAsset.order_by(:media_file_name, 'ASC').map{|f| %{<option value="#{f.media.url}">#{f.name}</option>} }].flatten.to_s
        options_for_media_assets(:flash).should == _expected
      end
      
      it 'populates options for image assets' do
        _expected = [@select, ImageAsset.order_by(:media_file_name, 'ASC').map{|f| %{<option value="#{f.media.url}">#{f.name}</option>} }].flatten.to_s
        options_for_media_assets(:image).should == _expected
      end
      
      it 'populates options for pdf assets' do
        _expected = [@select, PdfAsset.order_by(:media_file_name, 'ASC').map{|f| %{<option value="#{f.media.url}">#{f.name}</option>} }].flatten.to_s
        options_for_media_assets(:pdf).should == _expected
      end
      
      it 'populates options for quicktime assets' do
        _expected = [@select, QuicktimeAsset.order_by(:media_file_name, 'ASC').map{|f| %{<option value="#{f.media.url}">#{f.name}</option>} }].flatten.to_s
        options_for_media_assets(:quicktime).should == _expected
      end

      it 'creates a tag for a flash asset' do
        f = FlashAsset.first
        tag_for_flash(f).include?(f.media.url).should be_true
      end
      
      it 'creates a tag for a pdf asset' do
        f = PdfAsset.first
        tag_for_pdf(f).include?(f.media.url).should be_true
      end
      
      it 'creates a tag for a quicktime asset' do
        f = QuicktimeAsset.first
        _tag = tag_for_quicktime(f)
        (_tag =~ /<object/ && _tag =~ /<\/object>/ && _tag.include?(f.media.url)).should be_true
      end
      
    end
    
  end

  # ============================================= CRUD =============================================

  describe 'CRUD GET show' do
  
    before do
      @site_page = SitePage.make(:site_section => @site_section)
      @site_page.publish!
    end
    
    it 'scopes a site page by ID' do
      get :show, :id => @site_page
      response.should render_template(:show)
      assigns(:site_page).should == @site_page
      response.should be_success
    end
    
    it 'scopes a site page by URL' do
      @site_page = SitePage.make
      @site_page.publish!
      get :show, :url => @site_page.url[1..-1].split('/')
      response.should render_template(:show)
      assigns(:site_page).should == @site_page
      response.should be_success
    end
    
    it 'returns a 404 if no matching, published page could be found' #FIXME
    
    it 'only displays a site page that has been published' do
      @draft_page = SitePage.make # Default draft
      get :show, :id => @draft_page
      response.code.should == '404'
    end    
    
    it 'only displays the published version of a site page that has both draft and published versions' do
      @site_page.update_attribute(:page_title, 'This is a test.')
      get :show, :id => @site_page
      response.should render_template(:show)
      assigns(:site_page).page_title.should == SitePage.published.find(@site_page).page_title
      response.should be_success
    end
    
    it 'displays sidebar links appropriate to the site section' do
      @site_section = @site_page.site_section
      5.times{ @site_section.sidebar_items << SidebarItem.make }
      get :show, :id => @site_page
      assigns(:sidebar_items).should == @site_section.sidebar_items
    end
    
    it 'displays an edit link to admins' do
      login_as_admin
      get :show, :id => @site_page
      response.should have_tag('a#site_page_edit_link')      
    end
    
    it 'does not display an edit link to public users' do
      get :show, :id => @site_page
      response.should_not have_tag('a#site_page_edit_link')      
    end

  end
  
  describe 'CRUD GET new' do
  
    it 'does not allow public users to view the new site_page page' do
      get :new, :site_section_id => @site_section.id
      response.should redirect_to(new_session_path)
    end

    it 'allows admins to view the new site_page page' do
      login_as_admin
      get :new, :site_section_id => @site_section.id
      response.should render_template(:new)
      response.should be_success
    end

    it 'auto-populates the slug with the site section url if no root page exists for the section' do
      login_as_admin
      get :new, :site_section_id => @site_section.id
      assigns(:site_page).slug.should == @site_section.root_url
    end

    it 'auto-populates the page title with the site section name if no root page exists for the section' do
      login_as_admin
      get :new, :site_section_id => @site_section.id
      assigns(:site_page).page_title.should == @site_section.name
    end

 end

  describe 'CRUD POST create' do
  
    describe 'with valid params' do
      it 'does not allow public users to create site_pages' do
        create_site_page
        response.should redirect_to(new_session_path)
      end

      it 'allows admins to create site_pages' do
        login_as_admin
        lambda do
          create_site_page
        end.should change(SitePage, :count).by(1)
        response.should be_redirect
      end

    end
    
    describe 'with invalid params' do
      it 'redirects to new' do
        login_as_admin
        create_site_page :page_title => nil
        response.should render_template(:new)
        assigns(:site_page).errors.should_not be_empty
      end
      
    end

    # Rcov reports scoping with preview as unexecuted
    it 'displays a preview page' do
      login_as_admin
      _ss = SiteSection.make
      @new = SitePage.make_unsaved
      @new.attributes = options
      @new.content = 'Just for preview.'
      post :create, :site_page => @new.attributes, :site_section_id => _ss.id, :preview => true, :commit => 'Preview'
      response.should render_template(:show)
      assigns(:site_page).content.should == 'Just for preview.'
      @new.new_record?.should be_true
    end
    
  end

  describe 'CRUD GET edit' do
    
    before do
      @site_page = SitePage.make
    end

    it 'allows admin access to edit a site_page' do
      login_as_admin
      get :edit, :id => @site_page
      response.should render_template(:edit)
      response.should be_success
    end

    it 'disallows public access to edit a site_page' do
      get :edit, :id => @site_page
      response.should redirect_to(new_session_path)
    end
    
    it 'displays an audit trail' do
      @site_page.update_attribute(:page_title, 'Revised Title')
      login_as_admin
      get :edit, :id => @site_page
      response.should render_template(:edit)
      assigns(:audit_trail).should_not be_empty
    end

  end
  
  describe 'CRUD PUT update ' do
  
    before do
      @site_page_4 = SitePage.make
    end
  
    describe 'with valid params' do

      it 'allows admins to update' do
        login_as_admin
        put :update, :id => @site_page_4.id, :site_page => { :page_title => 'Fluffy Bunny' }
        SitePage.find(@site_page_4).page_title.should eql('Fluffy Bunny')
        response.should be_redirect
      end

      it 'disallows public users to update' do
        put :update, :id => @site_page_4.id, :site_page => { :page_title => 'Bugs Bunny' }
        SitePage.find(@site_page_4).page_title.should_not eql('Bugs Bunny')
      end
      
      it 'allows admins to publish' do
        login_as_admin
        _new = SitePage.make
        put :update, :id => _new.id, :commit => "Publish"
        _new.reload.published?.should be_true
      end
      
    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @site_page_4.id, :site_page => { :page_title => '' }
        response.should render_template(:edit)
        SitePage.find(@site_page_4).page_title.should_not be_nil
      end
    end

    it 'displays a preview page' do
      login_as_admin
      put :update, :id => @site_page_4.id, :site_page => { :content => 'Revision' }, :commit => 'Preview'
      response.should render_template(:show)
      assigns(:site_page).content.should == 'Revision'
      @site_page_4.reload.content.should_not == 'Revision'
    end
    
  end

  describe 'CRUD DELETE destroy' do
  
    before do
      @site_page_5 = SitePage.make
    end
    
    describe 'with valid params' do
      it 'allows admins to destroy a site_page' do
        login_as_admin
        delete :destroy, :id => @site_page_5.id
        SitePage.exists?( @site_page_5.id ).should be_false
        response.should be_redirect
      end

      it 'does not allow public users to destroy a site_page' do
        delete :destroy, :id => @site_page_5.id
        SitePage.exists?( @site_page_5.id ).should be_true
      end

    end

    describe 'with invalid params' do
      integrate_views

      it 'redirects to 404'

    end
  end

end

# ============================================= Routes =============================================

describe RubricCms::SitePagesController do

  describe "route generation" do

    it "should route site_pages 'new' action correctly" do
      route_for(:controller => 'rubric_cms/site_pages', :action => 'new', :site_section_id => '1').should == "/site_sections/1/site_pages/new"
    end

    it "should route {:controller => 'rubric_cms/site_pages', :action => 'create'} correctly" do
      route_for(:controller => 'rubric_cms/site_pages', :action => 'create', :site_section_id => '1').should == { :path => "/site_sections/1/site_pages", :method => :post }
    end

    it "should route site_pages 'show' action correctly provided an ID" do
      route_for(:controller => 'rubric_cms/site_pages', :action => 'show', :site_section_id => '1', :id => '2').should == "/site_sections/1/site_pages/2"
    end

    it "should route site_pages 'show' action correctly provided a URL" do
      route_for(:controller => 'rubric_cms/site_pages', :action => 'show', :url => ["foo", "bar"]).should == { :path => "/foo/bar/", :method => :get, :url => ["foo", "bar"] }
    end

    it "should route site_pages 'edit' action correctly" do
      route_for(:controller => 'rubric_cms/site_pages', :action => 'edit', :site_section_id => '1', :id => '2').should == "/site_sections/1/site_pages/2/edit"
    end

    it "should route site_pages 'update' action correctly" do
      route_for(:controller => 'rubric_cms/site_pages', :action => 'update', :site_section_id => '1', :id => '2').should == { :path => "/site_sections/1/site_pages/2", :method => :put }
    end

    it "should route site_pages 'destroy' action correctly" do
      route_for(:controller => 'rubric_cms/site_pages', :action => 'destroy', :site_section_id => '1', :id => '2').should == { :path => "/site_sections/1/site_pages/2", :method => :delete }
    end

  end

  describe "route recognition" do

    it "should generate params for site_pages new action from GET /site_sections/1/site_pages" do
      params_from(:get, '/site_sections/1/site_pages/new').should == {:controller => 'rubric_cms/site_pages', :action => 'new', :site_section_id => '1'}
    end

    it "should generate params for site_pages create action from POST /site_sections/1/site_pages" do
      params_from(:post, '/site_sections/1/site_pages').should == {:controller => 'rubric_cms/site_pages', :action => 'create', :site_section_id => '1'}
    end

    it "should generate params for site_pages show action from GET /site_sections/1/site_pages/2" do
      params_from(:get , '/site_sections/1/site_pages/2').should == {:controller => 'rubric_cms/site_pages', :action => 'show', :id => '2', :site_section_id => '1'}
    end

    it "should generate params for site_pages edit action from GET /site_sections/1/site_pages/2/edit" do
      params_from(:get , '/site_sections/1/site_pages/2/edit').should == {:controller => 'rubric_cms/site_pages', :action => 'edit', :id => '2', :site_section_id => '1'}
    end

    it "should generate params {:controller => 'rubric_cms/site_pages', :action => update', :id => '2'} from PUT /site_sections/1/site_pages/2" do
      params_from(:put , '/site_sections/1/site_pages/2').should == {:controller => 'rubric_cms/site_pages', :action => 'update', :id => '2', :site_section_id => '1'}
    end

    it "should generate params for site_pages destroy action from DELETE /site_sections/1/site_pages/2" do
      params_from(:delete, '/site_sections/1/site_pages/2').should == {:controller => 'rubric_cms/site_pages', :action => 'destroy', :id => '2', :site_section_id => '1'}
    end
  end

  describe "named routing" do
    before(:each) do
      get :new
    end

    it "should route new_site_section_site_page_path(1) to /site_sections/1/site_pages/new" do
      new_site_section_site_page_path(:site_section_id => '1').should == "/site_sections/1/site_pages/new"
    end

    it "should route site_page_(:id => '1') to /site_pages/2" do
      site_section_site_page_path(:site_section_id => '1', :id => '2').should == "/site_sections/1/site_pages/2"
    end

    it "should route edit_site_page_path(:id => '1') to /site_pages/2/edit" do
      edit_site_section_site_page_path(:site_section_id => '1', :id => '2').should == "/site_sections/1/site_pages/2/edit"
    end
  end

end

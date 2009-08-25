require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::SiteSectionsController do

  def create_site_section(options = {})
    _new = SiteSection.make_unsaved
    _new.attributes = options
    post :create, :site_section => _new.attributes
  end
  
  def make_site_section_with_sidebar_items(options = {})
    _new = SiteSection.make(options) do |ss|
      3.times { ss.sidebar_items.make }
    end
    _new
  end  
  
  def make_site_section_with_site_pages(options = {})
    _new = SiteSection.make(options)
    3.times do
      SitePage.make(:site_section_id => _new.id)
    end
    _new
  end  
  
  # ============================================ Custom ============================================


  # ============================================= CRUD =============================================

  it 'CRUD GET new' do
    login_as_admin
    get :new
    response.should render_template('new')
    response.should be_success
    assigns(:site_section).should_not be_nil
  end
  
  describe 'CRUD GET index' do
  
    integrate_views

    before do
      @site_section_1 = SiteSection.make
      @site_section_2 = SiteSection.make
      @site_section_3 = SiteSection.make
    end

    it 'does not list site_sections for public users' do
      get :index
      response.should redirect_to(new_session_path)
    end

    it 'lists site_sections for admin users' do
      login_as_admin
      get :index
      assigns(:site_sections).size.should == SiteSection.count
      response.should render_template('index')
      response.should be_success
    end
  end

  describe 'CRUD GET new' do
    it 'does not allow public users to view the new site_section page' do
      get :new
      response.should redirect_to(new_session_path)
    end

    it 'allows admins to view the new site_section page' do
      login_as_admin
      get :new
      response.should render_template(:new)
      response.should be_success
    end

  end

  describe 'CRUD POST create' do
  
    describe 'with valid params' do
      it 'does not allow public users to create site_sections' do
        create_site_section
        response.should redirect_to(new_session_path)
      end

      it 'allows admins to create site_sections' do
        login_as_admin
        lambda do
          create_site_section
        end.should change(SiteSection, :count).by(1)
        response.should be_redirect
      end

    end

    describe 'with invalid params' do
      it 'redirects to new' do
        login_as_admin
        create_site_section :name => nil
        response.should render_template(:new)
        assigns(:site_section).errors.should_not be_empty
      end
    end
  end

  describe 'CRUD GET edit' do
    
    before do
      @site_section = SiteSection.make
    end

    it 'allows admin access to edit a site_section' do
      login_as_admin
      get :edit, :id => @site_section
      response.should render_template(:edit)
      response.should be_success
    end

    it 'disallows public access to edit a site_section' do
      get :edit, :id => @site_section
      response.should redirect_to(new_session_path)
    end
    
  end
  
  describe 'CRUD PUT update ' do
  
    before do
      @site_section_4 = SiteSection.make
    end
  
    describe 'with valid params' do

      it 'allows admins to update' do
        login_as_admin
        put :update, :id => @site_section_4.id, :site_section => { :name => 'Fluffy Bunny' }
        SiteSection.find(@site_section_4).name.should eql('Fluffy Bunny')
        response.should be_redirect
      end

      it 'disallows public users to update' do
        put :update, :id => @site_section_4.id, :site_section => { :name => 'Bugs Bunny' }
        SiteSection.find(@site_section_4).name.should_not eql('Bugs Bunny')
      end
      
    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @site_section_4.id, :site_section => { :name => '' }
        response.should render_template(:edit)
        SiteSection.find(@site_section_4).name.should_not be_nil
      end
    end
  end

  describe 'CRUD SHOW' do
  
    before do
      @with_sidebar = make_site_section_with_sidebar_items
      @with_site_pages = make_site_section_with_site_pages
    end
    
    it 'does not allow public users to view a site section' do
      get :show, :id => @with_sidebar.id
      response.should redirect_to(new_session_path)
    end

    it 'allows admins to view a site section' do
      login_as_admin
      get :show, :id => @with_sidebar.id
      response.should render_template(:show)
      response.should be_success
    end
    
    it 'displays associated sidebar items' do
      login_as_admin
      get :show, :id => @with_sidebar.id
      assigns(:sidebar_items).size.should == 3
    end
    
    it 'displays associated site pages' do
      login_as_admin
      get :show, :id => @with_site_pages.id
      assigns(:site_pages).size.should == 3
    end
    
    it 'allows associated site pages to be sorted'
    
  end
  
  describe 'CRUD DELETE destroy' do
  
    before do
      @site_section_5 = SiteSection.make
    end
    
    describe 'with valid params' do
      it 'allows admins to destroy a site_section' do
        login_as_admin
        delete :destroy, :id => @site_section_5.id
        SiteSection.exists?( @site_section_5.id ).should be_false
        response.should be_redirect
      end

      it 'does not allow public users to destroy a site_section' do
        delete :destroy, :id => @site_section_5.id
        SiteSection.exists?( @site_section_5.id ).should be_true
      end

    end

    describe 'with invalid params' do
      integrate_views

      it 'redirects to 404'

    end
  end

end

# ============================================= Routes =============================================

describe RubricCms::SiteSectionsController do

  describe "route generation" do
    it "should route site_sections 'index' action correctly" do
      route_for(:controller => 'rubric_cms/site_sections', :action => 'index').should == "/site_sections"
    end

    it "should route site_sections 'new' action correctly" do
      route_for(:controller => 'rubric_cms/site_sections', :action => 'new').should == "/site_sections/new"
    end

    it "should route {:controller => 'rubric_cms/site_sections', :action => 'create'} correctly" do
      route_for(:controller => 'rubric_cms/site_sections', :action => 'create').should == { :path => "/site_sections", :method => :post }
    end

    it "should route site_sections 'show' action correctly" do
      route_for(:controller => 'rubric_cms/site_sections', :action => 'show', :id => '1').should == "/site_sections/1"
    end

    it "should route site_sections 'edit' action correctly" do
      route_for(:controller => 'rubric_cms/site_sections', :action => 'edit', :id => '1').should == "/site_sections/1/edit"
    end

    it "should route site_sections 'update' action correctly" do
      route_for(:controller => 'rubric_cms/site_sections', :action => 'update', :id => '1').should == { :path => "/site_sections/1", :method => :put }
    end

    it "should route site_sections 'destroy' action correctly" do
      route_for(:controller => 'rubric_cms/site_sections', :action => 'destroy', :id => '1').should == { :path => "/site_sections/1", :method => :delete }
    end

  end

  describe "route recognition" do
    it "should generate params for site_sections index action from GET /site_sections" do
      params_from(:get, '/site_sections').should == {:controller => 'rubric_cms/site_sections', :action => 'index'}
    end

    it "should generate params for site_sections new action from GET /site_sections" do
      params_from(:get, '/site_sections/new').should == {:controller => 'rubric_cms/site_sections', :action => 'new'}
    end

    it "should generate params for site_sections create action from POST /site_sections" do
      params_from(:post, '/site_sections').should == {:controller => 'rubric_cms/site_sections', :action => 'create'}
    end

    it "should generate params for site_sections show action from GET /site_sections/1" do
      params_from(:get , '/site_sections/1').should == {:controller => 'rubric_cms/site_sections', :action => 'show', :id => '1'}
    end

    it "should generate params for site_sections edit action from GET /site_sections/1/edit" do
      params_from(:get , '/site_sections/1/edit').should == {:controller => 'rubric_cms/site_sections', :action => 'edit', :id => '1'}
    end

    it "should generate params {:controller => 'rubric_cms/site_sections', :action => update', :id => '1'} from PUT /site_sections/1" do
      params_from(:put , '/site_sections/1').should == {:controller => 'rubric_cms/site_sections', :action => 'update', :id => '1'}
    end

    it "should generate params for site_sections destroy action from DELETE /site_sections/1" do
      params_from(:delete, '/site_sections/1').should == {:controller => 'rubric_cms/site_sections', :action => 'destroy', :id => '1'}
    end
  end

  describe "named routing" do
    before(:each) do
      get :new
    end

    it "should route site_sections_path() to /site_sections" do
      site_sections_path().should == "/site_sections"
    end

    it "should route new_site_section_path() to /site_sections/new" do
      new_site_section_path().should == "/site_sections/new"
    end

    it "should route site_section_(:id => '1') to /site_sections/1" do
      site_section_path(:id => '1').should == "/site_sections/1"
    end

    it "should route edit_site_section_path(:id => '1') to /site_sections/1/edit" do
      edit_site_section_path(:id => '1').should == "/site_sections/1/edit"
    end
  end

end

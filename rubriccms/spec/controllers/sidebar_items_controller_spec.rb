require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::SidebarItemsController do

  before do
    @site_section = SiteSection.make
  end
  
  def create_sidebar_item (options = {})
    _new = SidebarItem.make_unsaved
    _new.attributes = options
    _ss = SiteSection.make
    post :create, :sidebar_item => _new.attributes, :site_section_id => _ss.id
  end
  
  # ============================================ Custom ============================================

  describe 'CRUD POST reorder' do

    before do
      @sidebar_item_1 = @site_section.sidebar_items.make
      @sidebar_item_2 = @site_section.sidebar_items.make
      @sidebar_item_3 = @site_section.sidebar_items.make
    end

    it 'redirects the public to log in' do
      post :reorder, :itemlist => %w[3 2 1]
      response.should redirect_to(new_session_path)
    end

    it 'allows admins to reorder sidebar links' do
      login_as_admin
      post :reorder, :itemlist => [@sidebar_item_3.id, @sidebar_item_2.id, @sidebar_item_1.id]
      SidebarItem.find(@sidebar_item_1).position.should == 3
      SidebarItem.find(@sidebar_item_2).position.should == 2
      SidebarItem.find(@sidebar_item_3).position.should == 1
    end

  end

  # ============================================= CRUD =============================================

  describe 'CRUD GET new' do
    it 'does not allow public users to view the new sidebar_item page' do
      get :new, :site_section_id => @site_section.id
      response.should redirect_to(new_session_path)
    end

    it 'allows admins to view the new sidebar_item page' do
      login_as_admin
      get :new, :site_section_id => @site_section.id
      response.should render_template(:new)
      response.should be_success
    end

  end

  describe 'CRUD POST create' do
  
    describe 'with valid params' do
      it 'does not allow public users to create sidebar_items' do
        create_sidebar_item
        response.should redirect_to(new_session_path)
      end

      it 'allows admins to create sidebar_items' do
        login_as_admin
        lambda do
          create_sidebar_item
        end.should change(SidebarItem, :count).by(1)
        SidebarItem.last.site_section_id.should_not be_nil
        response.should be_redirect
      end

    end

    describe 'with invalid params' do
      it 'redirects to new' do
        login_as_admin
        create_sidebar_item :link_text => nil
        response.should render_template(:new)
        assigns(:sidebar_item).errors.should_not be_empty
      end
    end
  end

  describe 'CRUD GET edit' do
    
    before do
      @sidebar_item = SidebarItem.make
    end

    it 'allows admin access to edit a sidebar_item' do
      login_as_admin
      get :edit, :id => @sidebar_item
      response.should render_template(:edit)
      response.should be_success
    end

    it 'disallows public access to edit a sidebar_item' do
      get :edit, :id => @sidebar_item
      response.should redirect_to(new_session_path)
    end
    
  end
  
  describe 'CRUD PUT update ' do
  
    before do
      @sidebar_item_4 = SidebarItem.make
    end
  
    describe 'with valid params' do

      it 'allows admins to update' do
        login_as_admin
        put :update, :id => @sidebar_item_4.id, :sidebar_item => { :link_text => 'Fluffy Bunny' }
        SidebarItem.find(@sidebar_item_4).link_text.should eql('Fluffy Bunny')
        response.should be_redirect
      end

      it 'disallows public users to update' do
        put :update, :id => @sidebar_item_4.id, :sidebar_item => { :link_text => 'Bugs Bunny' }
        SidebarItem.find(@sidebar_item_4).link_text.should_not eql('Bugs Bunny')
      end
      
    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @sidebar_item_4.id, :sidebar_item => { :link_text => '' }
        response.should render_template(:edit)
        SidebarItem.find(@sidebar_item_4).link_text.should_not be_nil
      end
    end
  end

  describe 'CRUD DELETE destroy' do
  
    before do
      @sidebar_item_5 = SidebarItem.make
    end
    
    describe 'with valid params' do
      it 'allows admins to destroy a sidebar_item' do
        login_as_admin
        delete :destroy, :id => @sidebar_item_5.id
        SidebarItem.exists?( @sidebar_item_5.id ).should be_false
        response.should be_redirect
      end

      it 'does not allow public users to destroy a sidebar_item' do
        delete :destroy, :id => @sidebar_item_5.id
        SidebarItem.exists?( @sidebar_item_5.id ).should be_true
      end

    end

    describe 'with invalid params' do
      integrate_views

      it 'redirects to 404'

    end
  end

end

# ============================================= Routes =============================================

describe RubricCms::SidebarItemsController do

  describe "route generation" do
    it "should route sidebar_items 'new' action correctly" do
      route_for(:controller => 'rubric_cms/sidebar_items', :action => 'new').should == "/sidebar_items/new"
    end

    it "should route {:controller => 'rubric_cms/sidebar_items', :action => 'create'} correctly" do
      route_for(:controller => 'rubric_cms/sidebar_items', :action => 'create').should == { :path => "/sidebar_items", :method => :post }
    end

    it "should route sidebar_items 'show' action correctly" do
      route_for(:controller => 'rubric_cms/sidebar_items', :action => 'show', :id => '1').should == "/sidebar_items/1"
    end

    it "should route sidebar_items 'edit' action correctly" do
      route_for(:controller => 'rubric_cms/sidebar_items', :action => 'edit', :id => '1').should == "/sidebar_items/1/edit"
    end

    it "should route sidebar_items 'update' action correctly" do
      route_for(:controller => 'rubric_cms/sidebar_items', :action => 'update', :id => '1').should == { :path => "/sidebar_items/1", :method => :put }
    end

    it "should route sidebar_items 'destroy' action correctly" do
      route_for(:controller => 'rubric_cms/sidebar_items', :action => 'destroy', :id => '1').should == { :path => "/sidebar_items/1", :method => :delete }
    end

  end

  describe "route recognition" do
    it "should generate params for sidebar_items index action from GET /sidebar_items" do
      params_from(:get, '/sidebar_items').should == {:controller => 'rubric_cms/sidebar_items', :action => 'index'}
    end

    it "should generate params for sidebar_items new action from GET /sidebar_items" do
      params_from(:get, '/sidebar_items/new').should == {:controller => 'rubric_cms/sidebar_items', :action => 'new'}
    end

    it "should generate params for sidebar_items create action from POST /sidebar_items" do
      params_from(:post, '/sidebar_items').should == {:controller => 'rubric_cms/sidebar_items', :action => 'create'}
    end

    it "should generate params for sidebar_items show action from GET /sidebar_items/1" do
      params_from(:get , '/sidebar_items/1').should == {:controller => 'rubric_cms/sidebar_items', :action => 'show', :id => '1'}
    end

    it "should generate params for sidebar_items edit action from GET /sidebar_items/1/edit" do
      params_from(:get , '/sidebar_items/1/edit').should == {:controller => 'rubric_cms/sidebar_items', :action => 'edit', :id => '1'}
    end

    it "should generate params {:controller => 'rubric_cms/sidebar_items', :action => update', :id => '1'} from PUT /sidebar_items/1" do
      params_from(:put , '/sidebar_items/1').should == {:controller => 'rubric_cms/sidebar_items', :action => 'update', :id => '1'}
    end

    it "should generate params for sidebar_items destroy action from DELETE /sidebar_items/1" do
      params_from(:delete, '/sidebar_items/1').should == {:controller => 'rubric_cms/sidebar_items', :action => 'destroy', :id => '1'}
    end
  end

  describe "named routing" do
    before(:each) do
      get :new
    end

    it "should route sidebar_items_path() to /sidebar_items" do
      sidebar_items_path().should == "/sidebar_items"
    end

    it "should route new_sidebar_item_path() to /sidebar_items/new" do
      new_sidebar_item_path().should == "/sidebar_items/new"
    end

    it "should route sidebar_item_(:id => '1') to /sidebar_items/1" do
      sidebar_item_path(:id => '1').should == "/sidebar_items/1"
    end

    it "should route edit_sidebar_item_path(:id => '1') to /sidebar_items/1/edit" do
      edit_sidebar_item_path(:id => '1').should == "/sidebar_items/1/edit"
    end
  end

end

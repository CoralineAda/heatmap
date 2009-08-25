require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::NavbarItemsController do

  def create_navbar_item(options = {})
    _new = NavbarItem.make_unsaved
    _new.attributes = options
    post :create, :navbar_item => _new.attributes
  end
    
  # ============================================ Custom ============================================

  describe 'CRUD POST reorder' do

    before do
      @navbar_item_1 = NavbarItem.make
      @navbar_item_2 = NavbarItem.make
      @navbar_item_3 = NavbarItem.make
    end

    it 'redirects the public to log in' do
      post :reorder, :navlist => %w[3 2 1]
      response.should redirect_to(new_session_path)
    end

    it 'allows admins to reorder top-level nav items' do
      login_as_admin
      post :reorder, :navlist => %w[3 2 1]
      NavbarItem.find(1).position.should == 3
      NavbarItem.find(2).position.should == 2
      NavbarItem.find(3).position.should == 1
    end

    it 'allows subnav items to be reordered' do
      login_as_admin
      _parent = NavbarItem.make
      _first = NavbarItem.make
      _first.move_to_child_of(_parent)
      _second = NavbarItem.make
      _second.move_to_child_of(_parent)
      _third = NavbarItem.make
      _third.move_to_child_of(_parent)
      post :reorder, :navlist => [_third.id, _first.id, _second.id]
      NavbarItem.find(_first).position.should == 2
      NavbarItem.find(_second).position.should == 3
      NavbarItem.find(_third).position.should == 1
    end
    
  end

  # ============================================= CRUD =============================================

  describe 'CRUD GET index' do

    integrate_views

    before do
      @navbar_item_1 = NavbarItem.make
      @navbar_item_2 = NavbarItem.make
      @navbar_item_3 = NavbarItem.make
    end

    it 'does not list navbar items for the public' do
      get :index
      response.should redirect_to(new_session_path)
    end

    it 'lists top-level navbar items for admin users' do
      login_as_admin
      get :index
      assigns(:navbar_items).size.should == NavbarItem.roots.size
      response.should render_template('index')
      response.should be_success
    end
  end

  describe 'CRUD GET new' do
    it 'does not allow public users to view the new navbar item page' do
      get :new
      response.should redirect_to(new_session_path)
    end

    it 'allows admins to view the new navbar item page' do
      login_as_admin
      get :new
      response.should render_template(:new)
      response.should be_success
    end

  end

  describe 'CRUD POST create' do
  
    describe 'with valid params' do
      it 'does not allow public users to create nav items' do
        create_navbar_item
        response.should redirect_to(new_session_path)
      end

      it 'allows admins to create nav items' do
        login_as_admin
        lambda do
          create_navbar_item
        end.should change(NavbarItem, :count).by(1)
        response.should be_redirect
      end

      it 'allows admins to create subnav items' do
        login_as_admin
        _parent = NavbarItem.make
        _new = NavbarItem.make_unsaved
        post :create, :navbar_item => _new.attributes, :parent_id => _parent.id
        NavbarItem.find(_parent).sub_nav_items.count.should == 1
        response.should be_redirect
      end
      
      it 'redirects to the parent nav item after creating a subnav item' do
        login_as_admin
        _parent = NavbarItem.make
        _new = NavbarItem.make_unsaved
        post :create, :navbar_item => _new.attributes, :parent_id => _parent.id
        response.should redirect_to(edit_navbar_item_path(_parent))
      end

    end

    describe 'with invalid params' do
      it 'redirects to new when admins try creating navbar items with invalid data' do
        login_as_admin
        create_navbar_item :link_text => nil
        response.should render_template(:new)
        assigns(:navbar_item).errors.should_not be_empty
      end
    end
  end

  describe 'CRUD GET edit' do
    
    before do
      @navbar_item = NavbarItem.make
    end

    it 'allows admin access to edit a top-level navbar item' do
      login_as_admin
      get :edit, :id => @navbar_item
      response.should render_template(:edit)
      response.should be_success
    end

    it 'disallows public access to edit a top-level navbar item' do
      get :edit, :id => @navbar_item
      response.should redirect_to(new_session_path)
    end
    
    it 'displays second-level nav items' do
      login_as_admin
      _subnav_item = NavbarItem.make
      _subnav_item.move_to_child_of(@navbar_item)
      get :edit, :id => @navbar_item
      assigns(:navbar_items).size.should == @navbar_item.children.size
      response.should be_success
    end
    
  end
  
  describe 'CRUD PUT update ' do
  
    before do
      @navbar_item_4 = NavbarItem.make
    end
  
    describe 'with valid params' do

      it 'allows admins to update' do
        login_as_admin
        put :update, :id => @navbar_item_4.id, :navbar_item => { :link_text => 'Fluffy Bunny' }
        NavbarItem.find(@navbar_item_4).link_text.should eql('Fluffy Bunny')
        response.should be_redirect
      end

      it 'disallows public users to update' do
        put :update, :id => @navbar_item_4.id, :navbar_item => { :link_text => 'Bugs Bunny' }
        NavbarItem.find(@navbar_item_4).link_text.should_not eql('Bugs Bunny')
      end
      
      it 'redirects to the parent nav item after updating a subnav item' do
        login_as_admin
        _parent = NavbarItem.make
        _child = NavbarItem.make
        _child.move_to_child_of(_parent)
        post :update, :id => _child.id, :navbar_item => { :link_text => 'Bunny Foo Foo' }, :parent_id => _parent.id
        response.should redirect_to(edit_navbar_item_path(_parent))
      end

    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @navbar_item_4.id, :navbar_item => { :link_text => '' }
        response.should render_template(:edit)
        NavbarItem.find(@navbar_item_4).link_text.should_not be_nil
      end
    end
  end

  describe 'CRUD DELETE destroy' do
  
    before do
      @navbar_item_5 = NavbarItem.make
    end
    
    describe 'with valid params' do
      it 'allows admins to destroy a nav item' do
        login_as_admin
        delete :destroy, :id => @navbar_item_5.id
        NavbarItem.exists?( @navbar_item_5.id ).should be_false
        response.should be_redirect
      end

      it 'does not allow public users to destroy a nav item' do
        delete :destroy, :id => @navbar_item_5.id
        NavbarItem.exists?( @navbar_item_5.id ).should be_true
      end

      it 'redirects to the parent nav item after destroying a subnav item' do
        login_as_admin
        _parent = NavbarItem.make
        _child = NavbarItem.make
        _child.move_to_child_of(_parent)
        delete :destroy, :id => _child.id
        response.should redirect_to(edit_navbar_item_path(_parent))
      end

    end

    describe 'with invalid params' do
      integrate_views

      it 'redirects to 404'

    end
  end

end

# ============================================= Routes =============================================

describe RubricCms::NavbarItemsController do

  describe "route generation" do
    it "should route navbar item 'index' action correctly" do
      route_for(:controller => 'rubric_cms/navbar_items', :action => 'index').should == "/navbar_items"
    end

    it "should route navbar item 'new' action correctly" do
      route_for(:controller => 'rubric_cms/navbar_items', :action => 'new').should == "/navbar_items/new"
    end

    it "should route {:controller => 'rubric_cms/navbar_items', :action => 'create'} correctly" do
      route_for(:controller => 'rubric_cms/navbar_items', :action => 'create').should == { :path => "/navbar_items", :method => :post }
    end

    it "should route navbar item 'show' action correctly" do
      route_for(:controller => 'rubric_cms/navbar_items', :action => 'show', :id => '1').should == "/navbar_items/1"
    end

    it "should route navbar item 'edit' action correctly" do
      route_for(:controller => 'rubric_cms/navbar_items', :action => 'edit', :id => '1').should == "/navbar_items/1/edit"
    end

    it "should route navbar item 'update' action correctly" do
      route_for(:controller => 'rubric_cms/navbar_items', :action => 'update', :id => '1').should == { :path => "/navbar_items/1", :method => :put }
    end

    it "should route navbar item 'destroy' action correctly" do
      route_for(:controller => 'rubric_cms/navbar_items', :action => 'destroy', :id => '1').should == { :path => "/navbar_items/1", :method => :delete }
    end

  end

  describe "route recognition" do
    it "should generate params for navbar item index action from GET /navbar_items" do
      params_from(:get, '/navbar_items').should == {:controller => 'rubric_cms/navbar_items', :action => 'index'}
    end

    it "should generate params for navbar item new action from GET /navbar_items" do
      params_from(:get, '/navbar_items/new').should == {:controller => 'rubric_cms/navbar_items', :action => 'new'}
    end

    it "should generate params for navbar item create action from POST /navbar_items" do
      params_from(:post, '/navbar_items').should == {:controller => 'rubric_cms/navbar_items', :action => 'create'}
    end

    it "should generate params for navbar item show action from GET /navbar_items/1" do
      params_from(:get , '/navbar_items/1').should == {:controller => 'rubric_cms/navbar_items', :action => 'show', :id => '1'}
    end

    it "should generate params for navbar item edit action from GET /navbar_items/1/edit" do
      params_from(:get , '/navbar_items/1/edit').should == {:controller => 'rubric_cms/navbar_items', :action => 'edit', :id => '1'}
    end

    it "should generate params {:controller => 'rubric_cms/navbar_items', :action => update', :id => '1'} from PUT /navbar_items/1" do
      params_from(:put , '/navbar_items/1').should == {:controller => 'rubric_cms/navbar_items', :action => 'update', :id => '1'}
    end

    it "should generate params for navbar item destroy action from DELETE /navbar_items/1" do
      params_from(:delete, '/navbar_items/1').should == {:controller => 'rubric_cms/navbar_items', :action => 'destroy', :id => '1'}
    end
  end

  describe "named routing" do
    before(:each) do
      get :new
    end

    it "should route navbar_items_path() to /navbar_items" do
      navbar_items_path().should == "/navbar_items"
    end

    it "should route new_navbar_item_path() to /navbar_items/new" do
      new_navbar_item_path().should == "/navbar_items/new"
    end

    it "should route navbar_item_(:id => '1') to /navbar_items/1" do
      navbar_item_path(:id => '1').should == "/navbar_items/1"
    end

    it "should route edit_navbar_item_path(:id => '1') to /navbar_items/1/edit" do
      edit_navbar_item_path(:id => '1').should == "/navbar_items/1/edit"
    end
  end

end

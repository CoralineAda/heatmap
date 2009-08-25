require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::FooterItemsController do

  def create_footer_item(options = {})
    _new = FooterItem.make_unsaved
    _new.attributes = options
    post :create, :footer_item => _new.attributes
  end
    
  # ============================================ Custom ============================================

  describe 'CRUD POST reorder' do

    before do
      @footer_item_1 = FooterItem.make(:position => 1)
      @footer_item_2 = FooterItem.make(:position => 2)
      @footer_item_3 = FooterItem.make(:position => 3)
    end

    it 'redirects the public to log in' do
      post :reorder, :itemlist => %w[3 2 1]
      response.should redirect_to(new_session_path)
    end

    it 'allows admins to reorder footer links' do
      login_as_admin
      post :reorder, :itemlist => [@footer_item_3.id, @footer_item_2.id, @footer_item_1.id]
      @footer_item_1.reload.position.should == 3
      @footer_item_2.reload.position.should == 2
      @footer_item_3.reload.position.should == 1
    end

  end

  # ============================================= CRUD =============================================

  describe 'CRUD GET index' do
  
    integrate_views

    before do
      @footer_item_1 = FooterItem.make
      @footer_item_2 = FooterItem.make
      @footer_item_3 = FooterItem.make
    end

    it 'does not list footer items for the public' do
      get :index
      response.should redirect_to(new_session_path)
    end

    it 'lists footer items for admin users' do
      login_as_admin
      get :index
      assigns(:footer_items).size.should == FooterItem.count
      response.should render_template('index')
      response.should be_success
    end
  end

  describe 'CRUD GET new' do
    it 'does not allow public users to view the new footer item page' do
      get :new
      response.should redirect_to(new_session_path)
    end

    it 'allows admins to view the new footer item page' do
      login_as_admin
      get :new
      response.should render_template(:new)
      response.should be_success
    end

  end

  describe 'CRUD POST create' do
  
    describe 'with valid params' do
      it 'does not allow public users to create footer links' do
        create_footer_item
        response.should redirect_to(new_session_path)
      end

      it 'allows admins to create footer links' do
        login_as_admin
        lambda do
          create_footer_item
        end.should change(FooterItem, :count).by(1)
        response.should be_redirect
      end

    end

    describe 'with invalid params' do
      it 'redirects to new when admins try creating footer items with invalid data' do
        login_as_admin
        create_footer_item :link_text => nil
        response.should render_template(:new)
        assigns(:footer_item).errors.should_not be_empty
      end
    end
  end

  describe 'CRUD GET edit' do
    
    before do
      @footer_item = FooterItem.make
    end

    it 'allows admin access to edit a footer item' do
      login_as_admin
      get :edit, :id => @footer_item
      response.should render_template(:edit)
      response.should be_success
    end

    it 'disallows public access to edit a footer item' do
      get :edit, :id => @footer_item
      response.should redirect_to(new_session_path)
    end
    
  end
  
  describe 'CRUD PUT update ' do
  
    before do
      @footer_item_4 = FooterItem.make
    end
  
    describe 'with valid params' do

      it 'allows admins to update' do
        login_as_admin
        put :update, :id => @footer_item_4.id, :footer_item => { :link_text => 'Fluffy Bunny' }
        FooterItem.find(@footer_item_4).link_text.should eql('Fluffy Bunny')
        response.should be_redirect
      end

      it 'disallows public users to update' do
        put :update, :id => @footer_item_4.id, :footer_item => { :link_text => 'Bugs Bunny' }
        FooterItem.find(@footer_item_4).link_text.should_not eql('Bugs Bunny')
      end
      
    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @footer_item_4.id, :footer_item => { :link_text => '' }
        response.should render_template(:edit)
        FooterItem.find(@footer_item_4).link_text.should_not be_nil
      end
    end
  end

  describe 'CRUD DELETE destroy' do
  
    before do
      @footer_item_5 = FooterItem.make
    end
    
    describe 'with valid params' do
      it 'allows admins to destroy a footer link' do
        login_as_admin
        delete :destroy, :id => @footer_item_5.id
        FooterItem.exists?( @footer_item_5.id ).should be_false
        response.should be_redirect
      end

      it 'does not allow public users to destroy a footer link' do
        delete :destroy, :id => @footer_item_5.id
        FooterItem.exists?( @footer_item_5.id ).should be_true
      end

    end

    describe 'with invalid params' do
      integrate_views

      it 'redirects to 404'

    end
  end

end

# ============================================= Routes =============================================

describe RubricCms::FooterItemsController do

  describe "route generation" do
    it "should route footer item 'index' action correctly" do
      route_for(:controller => 'rubric_cms/footer_items', :action => 'index').should == "/footer_items"
    end

    it "should route footer item 'new' action correctly" do
      route_for(:controller => 'rubric_cms/footer_items', :action => 'new').should == "/footer_items/new"
    end

    it "should route {:controller => 'rubric_cms/footer_items', :action => 'create'} correctly" do
      route_for(:controller => 'rubric_cms/footer_items', :action => 'create').should == { :path => "/footer_items", :method => :post }
    end

    it "should route footer item 'show' action correctly" do
      route_for(:controller => 'rubric_cms/footer_items', :action => 'show', :id => '1').should == "/footer_items/1"
    end

    it "should route footer item 'edit' action correctly" do
      route_for(:controller => 'rubric_cms/footer_items', :action => 'edit', :id => '1').should == "/footer_items/1/edit"
    end

    it "should route footer item 'update' action correctly" do
      route_for(:controller => 'rubric_cms/footer_items', :action => 'update', :id => '1').should == { :path => "/footer_items/1", :method => :put }
    end

    it "should route footer item 'destroy' action correctly" do
      route_for(:controller => 'rubric_cms/footer_items', :action => 'destroy', :id => '1').should == { :path => "/footer_items/1", :method => :delete }
    end

  end

  describe "route recognition" do
    it "should generate params for footer item index action from GET /footer_items" do
      params_from(:get, '/footer_items').should == {:controller => 'rubric_cms/footer_items', :action => 'index'}
    end

    it "should generate params for footer item new action from GET /footer_items" do
      params_from(:get, '/footer_items/new').should == {:controller => 'rubric_cms/footer_items', :action => 'new'}
    end

    it "should generate params for footer item create action from POST /footer_items" do
      params_from(:post, '/footer_items').should == {:controller => 'rubric_cms/footer_items', :action => 'create'}
    end

    it "should generate params for footer item show action from GET /footer_items/1" do
      params_from(:get , '/footer_items/1').should == {:controller => 'rubric_cms/footer_items', :action => 'show', :id => '1'}
    end

    it "should generate params for footer item edit action from GET /footer_items/1/edit" do
      params_from(:get , '/footer_items/1/edit').should == {:controller => 'rubric_cms/footer_items', :action => 'edit', :id => '1'}
    end

    it "should generate params {:controller => 'rubric_cms/footer_items', :action => update', :id => '1'} from PUT /footer_items/1" do
      params_from(:put , '/footer_items/1').should == {:controller => 'rubric_cms/footer_items', :action => 'update', :id => '1'}
    end

    it "should generate params for footer item destroy action from DELETE /footer_items/1" do
      params_from(:delete, '/footer_items/1').should == {:controller => 'rubric_cms/footer_items', :action => 'destroy', :id => '1'}
    end
  end

  describe "named routing" do
    before(:each) do
      get :new
    end

    it "should route footer_items_path() to /footer_items" do
      footer_items_path().should == "/footer_items"
    end

    it "should route new_footer_item_path() to /footer_items/new" do
      new_footer_item_path().should == "/footer_items/new"
    end

    it "should route footer_item_(:id => '1') to /footer_items/1" do
      footer_item_path(:id => '1').should == "/footer_items/1"
    end

    it "should route edit_footer_item_path(:id => '1') to /footer_items/1/edit" do
      edit_footer_item_path(:id => '1').should == "/footer_items/1/edit"
    end
  end

end

require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::ImageAssetsController do

  # ============================================= CRUD =============================================

  def create_image_asset(options = {})
    _new = ImageAsset.make_unsaved
    _new.attributes = options
    post :create, :image_asset => _new.attributes
  end

  describe 'CRUD GET new' do
    it 'redirects the public to log in' do
      get :new
      response.should redirect_to(new_session_path)
    end

    it 'allows admins' do
      login_as_admin
      get :new
      response.should render_template(:new)
      response.should be_success      
    end

  end

  describe 'CRUD POST create' do

    describe 'with valid params' do
      it 'redirects the public to log in' do
        create_image_asset
        response.should redirect_to(new_session_path)
      end

      it 'allows admins' do
        login_as_admin
        lambda do
          create_image_asset
        end.should change(ImageAsset, :count).by(1)
        response.should be_redirect
      end

    end

    describe 'with invalid params' do
      it 'redirects to new' do
        login_as_admin
        create_image_asset :media_file_name => nil
        response.should render_template(:new)
        assigns(:image_asset).errors.should_not be_empty
      end
    end
  end

  describe 'CRUD GET edit' do

    before do
      @image_asset = ImageAsset.make
    end

    it 'allows admins' do
      login_as_admin
      get :edit, :id => @image_asset.id
      response.should render_template(:edit)
      response.should be_success
    end

    it 'redirects the public to log in' do
      get :edit, :id => @image_asset.id
      response.should redirect_to(new_session_path)
    end

  end

  describe 'CRUD PUT update' do

    before do
      @image_asset = ImageAsset.make
    end

    describe 'with valid params' do

      it 'allows admins' do
        _description = 'Fluffy Bunny'
        login_as_admin
        put :update, :id => @image_asset.id, :image_asset => { :description => _description }
        @image_asset.reload.description.should == _description
        response.should be_redirect
      end

      it 'redirects the public to log in' do
        put :update, :id => @image_asset.id, :image_asset => { :name => 'Bugs Bunny' }
        @image_asset.reload.name.should_not eql('Bugs Bunny')
        response.should redirect_to(new_session_path)
      end

    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @image_asset.id, :image_asset => { :media_file_name => nil }
        response.should render_template(:edit)
        @image_asset.reload.media_file_name.should_not be_nil
      end
    end
  end

  describe 'CRUD DELETE destroy' do

    before do
      @image_asset_5 = ImageAsset.make
    end

    describe 'with valid params' do
      it 'allows admins' do
        login_as_admin
        delete :destroy, :id => @image_asset_5.id
        ImageAsset.exists?( @image_asset_5.id ).should be_false
        response.should be_redirect
      end

      it 'redirects the public log in' do
        delete :destroy, :id => @image_asset_5.id
        ImageAsset.exists?( @image_asset_5.id ).should be_true
        response.should redirect_to(new_session_path)
      end

    end

    describe 'with invalid params' do
      integrate_views

      it 'redirects to 404'

    end
  end

  # ============================================= Other =============================================
  
  it 'displays an image dialog page' do
    login_as_admin
    get :image_dialog
    response.should render_template(:image_dialog)
    response.should be_success
  end

end

# ============================================= Routes =============================================

describe RubricCms::ImageAssetsController do

  describe 'route generation' do
    it 'should route image_assets "new" action correctly' do
      route_for(:controller => 'rubric_cms/image_assets', :action => 'new').should == '/image_assets/new'
    end

    it 'should route {:controller => "rubric_cms/image_assets", :action => "create"} correctly' do
      route_for(:controller => 'rubric_cms/image_assets', :action => 'create').should == { :path => '/image_assets', :method => :post }
    end

    it 'should route image_assets "show" action correctly' do
      route_for(:controller => 'rubric_cms/image_assets', :action => 'show', :id => '1').should == '/image_assets/1'
    end

    it 'should route image_assets "edit" action correctly' do
      route_for(:controller => 'rubric_cms/image_assets', :action => 'edit', :id => '1').should == '/image_assets/1/edit'
    end

    it 'should route image_assets "update" action correctly' do
      route_for(:controller => 'rubric_cms/image_assets', :action => 'update', :id => '1').should == { :path => '/image_assets/1', :method => :put }
    end

    it 'should route image_assets "destroy" action correctly' do
      route_for(:controller => 'rubric_cms/image_assets', :action => 'destroy', :id => '1').should == { :path => '/image_assets/1', :method => :delete }
    end

  end

  describe 'route recognition' do
    it 'should generate params for image_assets new action from GET /image_assets' do
      params_from(:get, '/image_assets/new').should == {:controller => 'rubric_cms/image_assets', :action => 'new'}
    end

    it 'should generate params for image_assets create action from POST /image_assets' do
      params_from(:post, '/image_assets').should == {:controller => 'rubric_cms/image_assets', :action => 'create'}
    end

    it 'should generate params for image_assets show action from GET /image_assets/1' do
      params_from(:get , '/image_assets/1').should == {:controller => 'rubric_cms/image_assets', :action => 'show', :id => '1'}
    end

    it 'should generate params for image_assets edit action from GET /image_assets/1/edit' do
      params_from(:get , '/image_assets/1/edit').should == {:controller => 'rubric_cms/image_assets', :action => 'edit', :id => '1'}
    end

    it 'should generate params {:controller => "rubric_cms/image_assets", :action => update", :id => "1"} from PUT /image_assets/1' do
      params_from(:put , '/image_assets/1').should == {:controller => 'rubric_cms/image_assets', :action => 'update', :id => '1'}
    end

    it 'should generate params for image_assets destroy action from DELETE /image_assets/1' do
      params_from(:delete, '/image_assets/1').should == {:controller => 'rubric_cms/image_assets', :action => 'destroy', :id => '1'}
    end
  end

  describe 'named routing' do
    before(:each) do
      get :new
    end

    it 'should route new_image_asset_path() to /image_assets/new' do
      new_image_asset_path().should == '/image_assets/new'
    end

    it 'should route image_asset_(:id => "1") to /image_assets/1' do
      image_asset_path(:id => '1').should == '/image_assets/1'
    end

    it 'should route edit_image_asset_path(:id => "1") to /image_assets/1/edit' do
      edit_image_asset_path(:id => '1').should == '/image_assets/1/edit'
    end
  end

end

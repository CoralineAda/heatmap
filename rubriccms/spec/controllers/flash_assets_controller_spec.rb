require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::FlashAssetsController do

  # ============================================= CRUD =============================================

  def create_flash_asset(options = {})
    _new = FlashAsset.make_unsaved
    _new.attributes = options
    post :create, :flash_asset => _new.attributes
  end

  describe 'CRUD GET index' do
  
    before do
      FlashAsset.destroy_all
      @f1 = FlashAsset.make(:media_file_name => "flash_1.swf")
      @f2 = FlashAsset.make(:media_file_name => "flash_2.swf")
    end
      
    it 'returns a JSON index' do
      login_as_admin
      get :index
      response.body.should == "[{\"filename\": \"#{@f1.name}\", \"url\": \"#{@f1.media.url}\"}, {\"filename\": \"#{@f2.name}\", \"url\": \"#{@f2.media.url}\"}]"
    end
   
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
        create_flash_asset
        response.should redirect_to(new_session_path)
      end

      it 'allows admins' do
        login_as_admin
        lambda do
          create_flash_asset
        end.should change(FlashAsset, :count).by(1)
        response.should be_redirect
      end

    end

    describe 'with invalid params' do
      it 'redirects to new' do
        login_as_admin
        create_flash_asset :media_file_name => nil
        response.should render_template(:new)
        assigns(:flash_asset).errors.should_not be_empty
      end
    end
  end

  describe 'CRUD GET edit' do

    before do
      @flash_asset = FlashAsset.make
    end

    it 'allows admins' do
      login_as_admin
      get :edit, :id => @flash_asset.id
      response.should render_template(:edit)
      response.should be_success
    end

    it 'redirects the public to log in' do
      get :edit, :id => @flash_asset.id
      response.should redirect_to(new_session_path)
    end

  end

  describe 'CRUD PUT update' do

    before do
      @flash_asset_4 = FlashAsset.make
    end

    describe 'with valid params' do

      it 'allows admins' do
        login_as_admin
        put :update, :id => @flash_asset_4.id, :flash_asset => { :name => 'Fluffy Bunny' }
        @flash_asset_4.reload.name.should eql('Fluffy Bunny')
        response.should be_redirect
      end

      it 'redirects the public to log in' do
        put :update, :id => @flash_asset_4.id, :flash_asset => { :name => 'Bugs Bunny' }
        @flash_asset_4.reload.name.should_not eql('Bugs Bunny')
        response.should redirect_to(new_session_path)
      end

    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @flash_asset_4.id, :flash_asset => { :media_file_name => nil }
        response.should render_template(:edit)
        @flash_asset_4.reload.media_file_name.should_not be_nil
      end
    end
  end

  describe 'CRUD DELETE destroy' do

    before do
      @flash_asset_5 = FlashAsset.make
    end

    describe 'with valid params' do
      it 'allows admins' do
        login_as_admin
        delete :destroy, :id => @flash_asset_5.id
        FlashAsset.exists?( @flash_asset_5.id ).should be_false
        response.should be_redirect
      end

      it 'redirects the public log in' do
        delete :destroy, :id => @flash_asset_5.id
        FlashAsset.exists?( @flash_asset_5.id ).should be_true
        response.should redirect_to(new_session_path)
      end

    end

    describe 'with invalid params' do
      integrate_views

      it 'redirects to 404'
      
    end
    
  end

end

# ============================================= Routes =============================================

describe RubricCms::FlashAssetsController do

  describe 'route generation' do
    it 'should route flash_assets "new" action correctly' do
      route_for(:controller => 'rubric_cms/flash_assets', :action => 'new').should == '/flash_assets/new'
    end

    it 'should route {:controller => "rubric_cms/flash_assets", :action => "create"} correctly' do
      route_for(:controller => 'rubric_cms/flash_assets', :action => 'create').should == { :path => '/flash_assets', :method => :post }
    end

    it 'should route flash_assets "show" action correctly' do
      route_for(:controller => 'rubric_cms/flash_assets', :action => 'show', :id => '1').should == '/flash_assets/1'
    end

    it 'should route flash_assets "edit" action correctly' do
      route_for(:controller => 'rubric_cms/flash_assets', :action => 'edit', :id => '1').should == '/flash_assets/1/edit'
    end

    it 'should route flash_assets "update" action correctly' do
      route_for(:controller => 'rubric_cms/flash_assets', :action => 'update', :id => '1').should == { :path => '/flash_assets/1', :method => :put }
    end

    it 'should route flash_assets "destroy" action correctly' do
      route_for(:controller => 'rubric_cms/flash_assets', :action => 'destroy', :id => '1').should == { :path => '/flash_assets/1', :method => :delete }
    end

  end

  describe 'route recognition' do
    it 'should generate params for flash_assets new action from GET /flash_assets' do
      params_from(:get, '/flash_assets/new').should == {:controller => 'rubric_cms/flash_assets', :action => 'new'}
    end

    it 'should generate params for flash_assets create action from POST /flash_assets' do
      params_from(:post, '/flash_assets').should == {:controller => 'rubric_cms/flash_assets', :action => 'create'}
    end

    it 'should generate params for flash_assets show action from GET /flash_assets/1' do
      params_from(:get , '/flash_assets/1').should == {:controller => 'rubric_cms/flash_assets', :action => 'show', :id => '1'}
    end

    it 'should generate params for flash_assets edit action from GET /flash_assets/1/edit' do
      params_from(:get , '/flash_assets/1/edit').should == {:controller => 'rubric_cms/flash_assets', :action => 'edit', :id => '1'}
    end

    it 'should generate params {:controller => "rubric_cms/flash_assets", :action => update", :id => "1"} from PUT /flash_assets/1' do
      params_from(:put , '/flash_assets/1').should == {:controller => 'rubric_cms/flash_assets', :action => 'update', :id => '1'}
    end

    it 'should generate params for flash_assets destroy action from DELETE /flash_assets/1' do
      params_from(:delete, '/flash_assets/1').should == {:controller => 'rubric_cms/flash_assets', :action => 'destroy', :id => '1'}
    end
  end

  describe 'named routing' do
    before(:each) do
      get :new
    end

    it 'should route new_flash_asset_path() to /flash_assets/new' do
      new_flash_asset_path().should == '/flash_assets/new'
    end

    it 'should route flash_asset_(:id => "1") to /flash_assets/1' do
      flash_asset_path(:id => '1').should == '/flash_assets/1'
    end

    it 'should route edit_flash_asset_path(:id => "1") to /flash_assets/1/edit' do
      edit_flash_asset_path(:id => '1').should == '/flash_assets/1/edit'
    end
  end

end

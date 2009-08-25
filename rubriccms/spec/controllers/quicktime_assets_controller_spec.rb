require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::QuicktimeAssetsController do

  # ============================================= CRUD =============================================

  def create_quicktime_asset(options = {})
    _new = QuicktimeAsset.make_unsaved
    _new.attributes = options
    post :create, :quicktime_asset => _new.attributes
  end


  describe 'CRUD GET index' do

    before do
      QuicktimeAsset.destroy_all
      @q1 = QuicktimeAsset.make(:media_file_name => "qt_1.mov")
      @q2 = QuicktimeAsset.make(:media_file_name => "qt_2.mov")
    end
      
    it 'returns a JSON index' do
      login_as_admin
      get :index
      response.body.should == "[{\"filename\": \"#{@q1.name}\", \"url\": \"#{@q1.media.url}\"}, {\"filename\": \"#{@q2.name}\", \"url\": \"#{@q2.media.url}\"}]"
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
        create_quicktime_asset
        response.should redirect_to(new_session_path)
      end

      it 'allows admins' do
        login_as_admin
        lambda do
          create_quicktime_asset
        end.should change(QuicktimeAsset, :count).by(1)
        response.should be_redirect
      end

    end

    describe 'with invalid params' do
      it 'redirects to new' do
        login_as_admin
        create_quicktime_asset :media_file_name => nil
        response.should render_template(:new)
        assigns(:quicktime_asset).errors.should_not be_empty
      end
    end
  end

  describe 'CRUD GET edit' do

    before do
      @quicktime_asset = QuicktimeAsset.make
    end

    it 'allows admins' do
      login_as_admin
      get :edit, :id => @quicktime_asset.id
      response.should render_template(:edit)
      response.should be_success
    end

    it 'redirects the public to log in' do
      get :edit, :id => @quicktime_asset.id
      response.should redirect_to(new_session_path)
    end

  end

  describe 'CRUD PUT update' do

    before do
      @quicktime_asset_4 = QuicktimeAsset.make
    end

    describe 'with valid params' do

      it 'allows admins' do
        login_as_admin
        put :update, :id => @quicktime_asset_4.id, :quicktime_asset => { :name => 'Fluffy Bunny' }
        @quicktime_asset_4.reload.name.should eql('Fluffy Bunny')
        response.should be_redirect
      end

      it 'redirects the public to log in' do
        put :update, :id => @quicktime_asset_4.id, :quicktime_asset => { :name => 'Bugs Bunny' }
        @quicktime_asset_4.reload.name.should_not eql('Bugs Bunny')
        response.should redirect_to(new_session_path)
      end

    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @quicktime_asset_4.id, :quicktime_asset => { :media_file_name => nil }
        response.should render_template(:edit)
        @quicktime_asset_4.reload.media_file_name.should_not be_nil
      end
    end
  end

  describe 'CRUD DELETE destroy' do

    before do
      @quicktime_asset_5 = QuicktimeAsset.make
    end

    describe 'with valid params' do
      it 'allows admins' do
        login_as_admin
        delete :destroy, :id => @quicktime_asset_5.id
        QuicktimeAsset.exists?( @quicktime_asset_5.id ).should be_false
        response.should be_redirect
      end

      it 'redirects the public log in' do
        delete :destroy, :id => @quicktime_asset_5.id
        QuicktimeAsset.exists?( @quicktime_asset_5.id ).should be_true
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

describe RubricCms::QuicktimeAssetsController do

  describe 'route generation' do
    it 'should route quicktime_assets "new" action correctly' do
      route_for(:controller => 'rubric_cms/quicktime_assets', :action => 'new').should == '/quicktime_assets/new'
    end

    it 'should route {:controller => "quicktime_assets", :action => "create"} correctly' do
      route_for(:controller => 'rubric_cms/quicktime_assets', :action => 'create').should == { :path => '/quicktime_assets', :method => :post }
    end

    it 'should route quicktime_assets "show" action correctly' do
      route_for(:controller => 'rubric_cms/quicktime_assets', :action => 'show', :id => '1').should == '/quicktime_assets/1'
    end

    it 'should route quicktime_assets "edit" action correctly' do
      route_for(:controller => 'rubric_cms/quicktime_assets', :action => 'edit', :id => '1').should == '/quicktime_assets/1/edit'
    end

    it 'should route quicktime_assets "update" action correctly' do
      route_for(:controller => 'rubric_cms/quicktime_assets', :action => 'update', :id => '1').should == { :path => '/quicktime_assets/1', :method => :put }
    end

    it 'should route quicktime_assets "destroy" action correctly' do
      route_for(:controller => 'rubric_cms/quicktime_assets', :action => 'destroy', :id => '1').should == { :path => '/quicktime_assets/1', :method => :delete }
    end

  end

  describe 'route recognition' do
    it 'should generate params for quicktime_assets new action from GET /quicktime_assets' do
      params_from(:get, '/quicktime_assets/new').should == {:controller => 'rubric_cms/quicktime_assets', :action => 'new'}
    end

    it 'should generate params for quicktime_assets create action from POST /quicktime_assets' do
      params_from(:post, '/quicktime_assets').should == {:controller => 'rubric_cms/quicktime_assets', :action => 'create'}
    end

    it 'should generate params for quicktime_assets show action from GET /quicktime_assets/1' do
      params_from(:get , '/quicktime_assets/1').should == {:controller => 'rubric_cms/quicktime_assets', :action => 'show', :id => '1'}
    end

    it 'should generate params for quicktime_assets edit action from GET /quicktime_assets/1/edit' do
      params_from(:get , '/quicktime_assets/1/edit').should == {:controller => 'rubric_cms/quicktime_assets', :action => 'edit', :id => '1'}
    end

    it 'should generate params {:controller => "quicktime_assets", :action => update", :id => "1"} from PUT /quicktime_assets/1' do
      params_from(:put , '/quicktime_assets/1').should == {:controller => 'rubric_cms/quicktime_assets', :action => 'update', :id => '1'}
    end

    it 'should generate params for quicktime_assets destroy action from DELETE /quicktime_assets/1' do
      params_from(:delete, '/quicktime_assets/1').should == {:controller => 'rubric_cms/quicktime_assets', :action => 'destroy', :id => '1'}
    end
  end

  describe 'named routing' do
    before(:each) do
      get :new
    end

    it 'should route new_quicktime_asset_path() to /quicktime_assets/new' do
      new_quicktime_asset_path().should == '/quicktime_assets/new'
    end

    it 'should route quicktime_asset_(:id => "1") to /quicktime_assets/1' do
      quicktime_asset_path(:id => '1').should == '/quicktime_assets/1'
    end

    it 'should route edit_quicktime_asset_path(:id => "1") to /quicktime_assets/1/edit' do
      edit_quicktime_asset_path(:id => '1').should == '/quicktime_assets/1/edit'
    end
  end

end

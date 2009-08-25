require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::PdfAssetsController do

  # ============================================= CRUD =============================================

  def create_pdf_asset(options = {})
    _new = PdfAsset.make_unsaved
    _new.attributes = options
    post :create, :pdf_asset => _new.attributes
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
        create_pdf_asset
        response.should redirect_to(new_session_path)
      end

      it 'allows admins' do
        login_as_admin
        lambda do
          create_pdf_asset
        end.should change(PdfAsset, :count).by(1)
        response.should be_redirect
      end

    end

    describe 'with invalid params' do
      it 'redirects to new' do
        login_as_admin
        create_pdf_asset :media_file_name => nil
        response.should render_template(:new)
        assigns(:pdf_asset).errors.should_not be_empty
      end
    end
  end

  describe 'CRUD GET edit' do

    before do
      @pdf_asset = PdfAsset.make
    end

    it 'allows admins' do
      login_as_admin
      get :edit, :id => @pdf_asset.id
      response.should render_template(:edit)
      response.should be_success
    end

    it 'redirects the public to log in' do
      get :edit, :id => @pdf_asset.id
      response.should redirect_to(new_session_path)
    end

  end

  describe 'CRUD PUT update' do

    before do
      @pdf_asset_4 = PdfAsset.make
    end

    describe 'with valid params' do

      it 'allows admins' do
        login_as_admin
        put :update, :id => @pdf_asset_4.id, :pdf_asset => { :name => 'Fluffy Bunny' }
        @pdf_asset_4.reload.name.should eql('Fluffy Bunny')
        response.should be_redirect
      end

      it 'redirects the public to log in' do
        put :update, :id => @pdf_asset_4.id, :pdf_asset => { :name => 'Bugs Bunny' }
        @pdf_asset_4.reload.name.should_not eql('Bugs Bunny')
        response.should redirect_to(new_session_path)
      end

    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @pdf_asset_4.id, :pdf_asset => { :media_file_name => nil }
        response.should render_template(:edit)
        @pdf_asset_4.reload.media_file_name.should_not be_nil
      end
    end
  end

  describe 'CRUD DELETE destroy' do

    before do
      @pdf_asset_5 = PdfAsset.make
    end

    describe 'with valid params' do
      it 'allows admins' do
        login_as_admin
        delete :destroy, :id => @pdf_asset_5.id
        PdfAsset.exists?( @pdf_asset_5.id ).should be_false
        response.should be_redirect
      end

      it 'redirects the public log in' do
        delete :destroy, :id => @pdf_asset_5.id
        PdfAsset.exists?( @pdf_asset_5.id ).should be_true
        response.should redirect_to(new_session_path)
      end

    end

    describe 'with invalid params' do
      integrate_views

      it 'redirects to 404'

    end
  end

  # ============================================= Other =============================================
  
  it 'displays a media dialog page' do
    login_as_admin
    get :mce_dialog
    response.should render_template(:mce_dialog)
    response.should be_success
  end

end

# ============================================= Routes =============================================

describe RubricCms::PdfAssetsController do

  describe 'route generation' do
    it 'should route pdf_assets "new" action correctly' do
      route_for(:controller => 'rubric_cms/pdf_assets', :action => 'new').should == '/pdf_assets/new'
    end

    it 'should route {:controller => "pdf_assets", :action => "create"} correctly' do
      route_for(:controller => 'rubric_cms/pdf_assets', :action => 'create').should == { :path => '/pdf_assets', :method => :post }
    end

    it 'should route pdf_assets "show" action correctly' do
      route_for(:controller => 'rubric_cms/pdf_assets', :action => 'show', :id => '1').should == '/pdf_assets/1'
    end

    it 'should route pdf_assets "edit" action correctly' do
      route_for(:controller => 'rubric_cms/pdf_assets', :action => 'edit', :id => '1').should == '/pdf_assets/1/edit'
    end

    it 'should route pdf_assets "update" action correctly' do
      route_for(:controller => 'rubric_cms/pdf_assets', :action => 'update', :id => '1').should == { :path => '/pdf_assets/1', :method => :put }
    end

    it 'should route pdf_assets "destroy" action correctly' do
      route_for(:controller => 'rubric_cms/pdf_assets', :action => 'destroy', :id => '1').should == { :path => '/pdf_assets/1', :method => :delete }
    end

  end

  describe 'route recognition' do
    it 'should generate params for pdf_assets new action from GET /pdf_assets' do
      params_from(:get, '/pdf_assets/new').should == {:controller => 'rubric_cms/pdf_assets', :action => 'new'}
    end

    it 'should generate params for pdf_assets create action from POST /pdf_assets' do
      params_from(:post, '/pdf_assets').should == {:controller => 'rubric_cms/pdf_assets', :action => 'create'}
    end

    it 'should generate params for pdf_assets show action from GET /pdf_assets/1' do
      params_from(:get , '/pdf_assets/1').should == {:controller => 'rubric_cms/pdf_assets', :action => 'show', :id => '1'}
    end

    it 'should generate params for pdf_assets edit action from GET /pdf_assets/1/edit' do
      params_from(:get , '/pdf_assets/1/edit').should == {:controller => 'rubric_cms/pdf_assets', :action => 'edit', :id => '1'}
    end

    it 'should generate params {:controller => "pdf_assets", :action => update", :id => "1"} from PUT /pdf_assets/1' do
      params_from(:put , '/pdf_assets/1').should == {:controller => 'rubric_cms/pdf_assets', :action => 'update', :id => '1'}
    end

    it 'should generate params for pdf_assets destroy action from DELETE /pdf_assets/1' do
      params_from(:delete, '/pdf_assets/1').should == {:controller => 'rubric_cms/pdf_assets', :action => 'destroy', :id => '1'}
    end
  end

  describe 'named routing' do
    before(:each) do
      get :new
    end

    it 'should route new_pdf_asset_path() to /pdf_assets/new' do
      new_pdf_asset_path().should == '/pdf_assets/new'
    end

    it 'should route pdf_asset_(:id => "1") to /pdf_assets/1' do
      pdf_asset_path(:id => '1').should == '/pdf_assets/1'
    end

    it 'should route edit_pdf_asset_path(:id => "1") to /pdf_assets/1/edit' do
      edit_pdf_asset_path(:id => '1').should == '/pdf_assets/1/edit'
    end
  end

end

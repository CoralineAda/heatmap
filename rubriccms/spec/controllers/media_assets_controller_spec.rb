require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::MediaAssetsController do

  # ============================================= CRUD =============================================

  describe 'CRUD GET index' do

    integrate_views

    before do
      3.times{ImageAsset.make}
      4.times{FlashAsset.make}
      5.times{PdfAsset.make}
      6.times{QuicktimeAsset.make}
    end

    it 'disallows the public' do
      get :index
      response.should redirect_to(new_session_path)
    end

    it 'allows admins' do
      login_as_admin
      get :index
      assigns(:media_assets).size.should == MediaAsset.count
      response.should render_template('index')
      response.should be_success
    end
    
    describe 'filters by'

      it 'all asset types' do
        login_as_admin
        get :index, :show => 'all'
        assigns(:media_assets).size.should == MediaAsset.count
        response.should be_success
      end
    
      it 'image assets' do
        login_as_admin
        get :index, :show => 'images'
        assigns(:media_assets).size.should == ImageAsset.count
        response.should be_success
      end
    
      it 'flash assets' do
        login_as_admin
        get :index, :show => 'flash'
        assigns(:media_assets).size.should == FlashAsset.count
        response.should be_success
      end
    
      it 'pdf assets' do
        login_as_admin
        get :index, :show => 'pdfs'
        assigns(:media_assets).size.should == PdfAsset.count
        response.should be_success
      end
    
      it 'quicktime assets' do
        login_as_admin
        get :index, :show => 'quicktime'
        assigns(:media_assets).size.should == QuicktimeAsset.count
        response.should be_success
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

describe RubricCms::MediaAssetsController do

  describe 'route generation' do
    it 'should route media_assets "index" action correctly' do
      route_for(:controller => 'rubric_cms/media_assets', :action => 'index').should == '/media_assets'
    end

  end

  describe 'route recognition' do
    it 'should generate params for media_assets index action from GET /media_assets' do
      params_from(:get, '/media_assets').should == {:controller => 'rubric_cms/media_assets', :action => 'index'}
    end
  end

  describe 'named routing' do
    before(:each) do
      get :new
    end
    it 'should route media_assets_path() to /media_assets' do
      media_assets_path().should == '/media_assets'
    end
  end

end

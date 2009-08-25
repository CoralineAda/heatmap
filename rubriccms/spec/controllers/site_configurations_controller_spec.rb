require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::SiteConfigurationsController do

  def create_site_configuration(options = {})
    _new = SiteConfiguration.make_unsaved
    _new.attributes = options
    post :create, :site_configuration => _new.attributes
  end

  # ============================================ Custom ============================================


  # ============================================= CRUD =============================================

  describe 'CRUD GET index' do

    integrate_views

    before do
      @site_configuration_1 = SiteConfiguration.make
      @site_configuration_2 = SiteConfiguration.make
      @site_configuration_3 = SiteConfiguration.make
    end

    it 'disallows the public' do
      get :index
      response.should redirect_to(new_session_path)
    end

    it 'allows admins' do
      login_as_admin
      get :index
      assigns(:site_configurations).size.should == SiteConfiguration.count
      response.should render_template('index')
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
    end

  end

  describe 'CRUD POST create' do

    describe 'with valid params' do
      it 'redirects the public to log in' do
        create_site_configuration
        response.should redirect_to(new_session_path)
      end

      it 'allows admins' do
        login_as_admin
        lambda do
          create_site_configuration
        end.should change(SiteConfiguration, :count).by(1)
      end

    end

    describe 'with invalid params' do
      it 'redirects to new' do
        login_as_admin
        create_site_configuration :site_name => nil
        response.should render_template(:new)
        assigns(:site_configuration).errors.should_not be_empty
      end
    end
  end

  describe 'CRUD GET edit' do

    before do
      @site_configuration = SiteConfiguration.make
    end

    it 'allows admins' do
      login_as_admin
      get :edit, :id => @site_configuration.id
      response.should render_template(:edit)
    end

    it 'redirects the public to log in' do
      get :edit, :id => @site_configuration.id
      response.should redirect_to(new_session_path)
    end

  end

  describe 'CRUD PUT update' do

    before do
      @site_configuration_4 = SiteConfiguration.make
    end

    describe 'with valid params' do

      it 'allows admins' do
        login_as_admin
        put :update, :id => @site_configuration_4.id, :site_configuration => { :site_name => 'Fluffy Bunny' }
        @site_configuration_4.reload.site_name.should eql('Fluffy Bunny')
      end

      it 'redirects the public to log in' do
        put :update, :id => @site_configuration_4.id, :site_configuration => { :site_name => 'Bugs Bunny' }
        @site_configuration_4.reload.site_name.should_not eql('Bugs Bunny')
        response.should redirect_to(new_session_path)
      end

    end

    describe 'with invalid params' do
      it 'redirects to edit' do
        login_as_admin
        put :update, :id => @site_configuration_4.id, :site_configuration => { :site_name => nil }
        response.should render_template(:edit)
        @site_configuration_4.reload.site_name.should_not be_nil
      end
    end
  end

  describe 'CRUD DELETE destroy' do

    before do
      @site_configuration_5 = SiteConfiguration.make
    end

    describe 'with valid params' do
      it 'allows admins' do
        login_as_admin
        delete :destroy, :id => @site_configuration_5.id
        SiteConfiguration.exists?( @site_configuration_5.id ).should be_false
      end

      it 'redirects the public log in' do
        delete :destroy, :id => @site_configuration_5.id
        SiteConfiguration.exists?( @site_configuration_5.id ).should be_true
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

describe RubricCms::SiteConfigurationsController do

  describe 'route generation' do
    it 'should route site_configurations "index" action correctly' do
      route_for(:controller => 'rubric_cms/site_configurations', :action => 'index').should == '/site_configurations'
    end

    it 'should route site_configurations "new" action correctly' do
      route_for(:controller => 'rubric_cms/site_configurations', :action => 'new').should == '/site_configurations/new'
    end

    it 'should route {:controller => "site_configurations", :action => "create"} correctly' do
      route_for(:controller => 'rubric_cms/site_configurations', :action => 'create').should == { :path => '/site_configurations', :method => :post }
    end

    it 'should route site_configurations "show" action correctly' do
      route_for(:controller => 'rubric_cms/site_configurations', :action => 'show', :id => '1').should == '/site_configurations/1'
    end

    it 'should route site_configurations "edit" action correctly' do
      route_for(:controller => 'rubric_cms/site_configurations', :action => 'edit', :id => '1').should == '/site_configurations/1/edit'
    end

    it 'should route site_configurations "update" action correctly' do
      route_for(:controller => 'rubric_cms/site_configurations', :action => 'update', :id => '1').should == { :path => '/site_configurations/1', :method => :put }
    end

    it 'should route site_configurations "destroy" action correctly' do
      route_for(:controller => 'rubric_cms/site_configurations', :action => 'destroy', :id => '1').should == { :path => '/site_configurations/1', :method => :delete }
    end

  end

  describe 'route recognition' do
    it 'should generate params for site_configurations index action from GET /site_configurations' do
      params_from(:get, '/site_configurations').should == {:controller => 'rubric_cms/site_configurations', :action => 'index'}
    end

    it 'should generate params for site_configurations new action from GET /site_configurations' do
      params_from(:get, '/site_configurations/new').should == {:controller => 'rubric_cms/site_configurations', :action => 'new'}
    end

    it 'should generate params for site_configurations create action from POST /site_configurations' do
      params_from(:post, '/site_configurations').should == {:controller => 'rubric_cms/site_configurations', :action => 'create'}
    end

    it 'should generate params for site_configurations show action from GET /site_configurations/1' do
      params_from(:get , '/site_configurations/1').should == {:controller => 'rubric_cms/site_configurations', :action => 'show', :id => '1'}
    end

    it 'should generate params for site_configurations edit action from GET /site_configurations/1/edit' do
      params_from(:get , '/site_configurations/1/edit').should == {:controller => 'rubric_cms/site_configurations', :action => 'edit', :id => '1'}
    end

    it 'should generate params {:controller => "site_configurations", :action => update", :id => "1"} from PUT /site_configurations/1' do
      params_from(:put , '/site_configurations/1').should == {:controller => 'rubric_cms/site_configurations', :action => 'update', :id => '1'}
    end

    it 'should generate params for site_configurations destroy action from DELETE /site_configurations/1' do
      params_from(:delete, '/site_configurations/1').should == {:controller => 'rubric_cms/site_configurations', :action => 'destroy', :id => '1'}
    end
  end

  describe 'named routing' do
    before(:each) do
      get :new
    end

    it 'should route site_configurations_path() to /site_configurations' do
      site_configurations_path().should == '/site_configurations'
    end

    it 'should route new_site_configuration_path() to /site_configurations/new' do
      new_site_configuration_path().should == '/site_configurations/new'
    end

    it 'should route site_configuration_(:id => "1") to /site_configurations/1' do
      site_configuration_path(:id => '1').should == '/site_configurations/1'
    end

    it 'should route edit_site_configuration_path(:id => "1") to /site_configurations/1/edit' do
      edit_site_configuration_path(:id => '1').should == '/site_configurations/1/edit'
    end
  end

end

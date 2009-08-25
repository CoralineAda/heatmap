require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::SiteMapController do

  # ============================================ Custom ============================================


  # ============================================= CRUD =============================================

  describe 'CRUD GET index' do

    integrate_views

    before do
      SitePage.destroy_all
      ss_1 = SiteSection.make(:root_url => '/pynchon')
      ss_2 = SiteSection.make(:root_url => '/eco')
      ss_3 = SiteSection.make(:root_url => '/rushdie')
      SitePage.make(:site_section => ss_1)
      SitePage.make(:site_section => ss_2)
      SitePage.make(:site_section => ss_3)
    end

    it 'displays an HTML version' do
      get :index
      assigns(:site_sections).size.should == 3
      response.should be_success
    end

    it 'displays an XML version' do
      get :index, :format => :xml
      assigns(:site_sections).size.should == 3
      response.should be_success
    end
  end

end

# ============================================= Routes =============================================

describe RubricCms::SiteMapController do

  describe 'route generation' do
    it 'should route site_map "index" action correctly' do
      route_for(:controller => 'rubric_cms/site_map', :action => 'index').should == '/sitemap'
    end
  end

  describe 'route recognition' do
    it 'should generate params for site_map index action from GET /sitemap' do
      params_from(:get, '/sitemap').should == {:controller => 'rubric_cms/site_map', :action => 'index'}
      params_from(:get, '/sitemap.xml').should == {:controller => 'rubric_cms/site_map', :action => 'index', :format => 'xml'}
    end
  end

  describe 'named routing' do

    it 'should route site_map_path() to /sitemap' do
      site_map_path().should == '/sitemap'
    end

  end

end

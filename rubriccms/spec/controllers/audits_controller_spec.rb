require File.dirname(__FILE__) + '/../spec_helper'

describe RubricCms::AuditsController do

  # ============================================ Custom ============================================


  # ============================================= CRUD =============================================

  describe 'CRUD GET show' do

    integrate_views

    before do
      @sp = SitePage.make
      @sp.page_title = 'New Title'
      @sp.save false
    end

    it 'disallows the public' do
      get :show, :id => @sp.audits.last
      response.should redirect_to(new_session_path)
    end

    it 'allows admins' do
      login_as_admin
      get :show, :id => @sp.audits.last
      response.should render_template(:show)
      assigns(:audit).should_not be_nil
    end
    
  end

end

# ============================================= Routes =============================================

describe RubricCms::AuditsController do

  describe 'route generation' do
    it 'should route audits "show" action correctly' do
      route_for(:controller => 'rubric_cms/audits', :action => 'show', :id => '1').should == '/audits/1'
    end
  end

  describe 'route recognition' do
    it 'should generate params for audits show action from GET /audits/1' do
      params_from(:get , '/audits/1').should == {:controller => 'rubric_cms/audits', :action => 'show', :id => '1'}
    end
  end

  describe 'named routing' do
    before(:each) do
      get :new
    end
    it 'should route audits_(:id => "1") to /audits/1' do
      audit_path(:id => '1').should == '/audits/1'
    end
  end

end

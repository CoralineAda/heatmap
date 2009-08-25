class RubricCms::SiteConfigurationsController < ApplicationController

  before_filter :login_required
  before_filter :scope_site_configuration, :only => [ :destroy, :edit, :show, :update ]

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges
  end

  # ========================================== CRUD ===========================================

  def index
    @site_configurations = SiteConfiguration.order_by(params[:by], params[:dir])
  end

  def show
  end

  def new
    @site_configuration = SiteConfiguration.new
  end

  def edit
  end

  def create
    @site_configuration = SiteConfiguration.new(params[:site_configuration])

    if @site_configuration.save
      flash[:notice] = 'SiteConfiguration was successfully created.'
      redirect_to site_configurations_path
    else
      render :action => "new"
    end
  end

  def update
    if @site_configuration.update_attributes(params[:site_configuration])
      flash[:notice] = 'SiteConfiguration was successfully updated.'
      redirect_to site_configurations_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @site_configuration.destroy
    redirect_to site_configurations_url
  end

  private

  def scope_site_configuration
    @site_configuration = SiteConfiguration.find(params[:id])
  end

end

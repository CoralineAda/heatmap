class RubricCms::SiteSectionsController < ApplicationController

  before_filter :login_required
  before_filter :scope_site_section, :only => [ :destroy, :edit, :show, :update ]

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges :create, :destroy, :edit, :new, :update
  end

  # ========================================== CRUD ===========================================

  def index
    params[:by] ||= :name; params[:dir] ||= 'ASC'
    @site_sections = SiteSection.order_by(params[:by], params[:dir])
    params[:labels] = {'active' => "Status"}
  end

  def show
    params[:labels] = {
      'state' => "Status",
      'user_id' => "Modified By",
      'updated_at' => "Last Modified",
      'link_title' => 'Mouseover Text'
    }
  end

  def new
    @site_section = SiteSection.new
  end

  def edit
  end

  def create
    @site_section = SiteSection.new(params[:site_section])

    if @site_section.save
      flash[:notice] = 'The site section was successfully created.'
      redirect_to @site_section
    else
      render :action => "new"
    end
  end

  def update
    if @site_section.update_attributes(params[:site_section])
      flash[:notice] = 'The site section was successfully updated.'
      redirect_to @site_section
    else
      render :action => "edit"
    end
  end

  def destroy
    @site_section.destroy
    redirect_to site_sections_url
  end

  private

  def scope_site_section
    @site_section = SiteSection.find(params[:id])
    @sidebar_items = @site_section.sidebar_items.order_by(:position, 'ASC')
    @site_pages = @site_section.site_pages.order_by(:url, 'ASC')
  end

end

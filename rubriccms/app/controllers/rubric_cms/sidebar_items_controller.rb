class RubricCms::SidebarItemsController < ApplicationController

  before_filter :login_required
  before_filter :scope_sidebar_item, :only => [ :destroy, :edit, :show, :update ]
  before_filter :scope_site_section, :only => [ :create, :new ]

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges :create, :destroy, :edit, :new, :reorder, :update
  end

  # ============================================ Custom ============================================

	def reorder
		order = params[:itemlist]
		order.each_with_index do |id, sort_order|
			SidebarItem.find(id).update_attribute(:position, sort_order + 1)
		end
		# Rails complains of a missing template without the following line.
		render :text => ''
	end

  # ========================================== CRUD ===========================================

  def show
  end

  def new
    @sidebar_item = SidebarItem.new
  end

  def edit
  end

  def create
    @sidebar_item = SidebarItem.new(params[:sidebar_item])
    @sidebar_item.site_section = SiteSection.find(params[:site_section_id])
    if @sidebar_item.save
      flash[:notice] = 'The sidebar link was successfully created.'
      redirect_to site_section_path(@site_section)
    else
      render :action => "new"
    end
  end

  def update
    if @sidebar_item.update_attributes(params[:sidebar_item])
      flash[:notice] = 'The sidebar link was successfully updated.'
      redirect_to site_section_path(@site_section)
    else
      render :action => "edit"
    end
  end

  def destroy
    @sidebar_item.destroy
    redirect_to site_section_url(@site_section)
  end

  private

  def scope_sidebar_item
    @sidebar_item = SidebarItem.find(params[:id])
    scope_site_section
  end

  def scope_site_section
    @site_section = @sidebar_item ? @sidebar_item.site_section : SiteSection.find(params[:site_section_id])
  end
  
end

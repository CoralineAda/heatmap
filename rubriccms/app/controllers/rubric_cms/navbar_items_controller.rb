class RubricCms::NavbarItemsController < ApplicationController

  before_filter :login_required
  before_filter :scope_navbar_item, :only => [ :destroy, :edit, :show, :update ]

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges :create, :destroy, :edit, :new, :reorder, :update
  end

  # ============================================ Custom ============================================

	def reorder
		order = params[:navlist]
		order.each_with_index do |id, sort_order|
			NavbarItem.find(id).update_attribute(:position, sort_order + 1)
		end
		# Rails complains of a missing template without the following line.
		render :text => ''
	end

  # ============================================ CRUD ============================================

  def index
    @navbar_items = NavbarItem.top_level
  end

  def show
  end

  def new
    @navbar_item = NavbarItem.new
    @navbar_item[:parent_id] = params[:parent_id]
  end

  def edit
    @navbar_items = @navbar_item.sub_nav_items
  end

  def create
    @navbar_item = NavbarItem.new(params[:navbar_item])
    if @navbar_item.save
      flash[:notice] = 'The navigation bar item was successfully created.'
      unless params[:parent_id] == "" || params[:parent_id].nil?
        @navbar_item.move_to_child_of(NavbarItem.find(params[:parent_id])) 
        redirect_to edit_navbar_item_path(@navbar_item.parent)
      else
        redirect_to navbar_items_path
      end
    else
      render :action => "new", :parent_id => params[:parent_id]
    end
  end

  def update
    if @navbar_item.update_attributes(params[:navbar_item])
      flash[:notice] = 'The navigation bar item was successfully updated.'
      if @navbar_item.parent_id.nil?
        redirect_to navbar_items_path
      else
        redirect_to edit_navbar_item_path(@navbar_item.parent)
      end
    else
      render :action => "edit"
    end
  end

  def destroy
    @navbar_item.destroy
      if @navbar_item.parent_id.nil?
        redirect_to navbar_items_path
      else
        redirect_to edit_navbar_item_path(@navbar_item.parent)
      end
  end

  private

  def scope_navbar_item
    @navbar_item = NavbarItem.find(params[:id])
  end
end

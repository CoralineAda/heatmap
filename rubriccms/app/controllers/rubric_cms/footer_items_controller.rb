class RubricCms::FooterItemsController < ApplicationController

  before_filter :login_required
  before_filter :scope_footer_item, :only => [ :destroy, :edit, :show, :update ]

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges :create, :destroy, :edit, :new, :reorder, :update
  end

  # ============================================ Custom ============================================

	def reorder
		order = params[:itemlist]
		order.each_with_index do |id, sort_order|
			FooterItem.find(id).update_attribute(:position, sort_order + 1)
		end
		# Rails complains of a missing template without the following line.
		render :text => ''
	end

  # ============================================ CRUD ============================================

  def index
    @footer_items = FooterItem.all
  end

  def show
  end

  def new
    @footer_item = FooterItem.new
  end

  def edit
  end

  def create
    @footer_item = FooterItem.new(params[:footer_item])
    if @footer_item.save
      flash[:notice] = 'The footer link was successfully created.'
      redirect_to footer_items_path
    else
      render :action => "new"
    end
  end

  def update
    if @footer_item.update_attributes(params[:footer_item])
      flash[:notice] = 'The footer link was successfully updated.'
      redirect_to footer_items_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @footer_item.destroy
    flash[:notice] = 'The footer link was successfully deleted.'
    redirect_to footer_items_path
  end

  private

  def scope_footer_item
    @footer_item = FooterItem.find(params[:id])
  end
end

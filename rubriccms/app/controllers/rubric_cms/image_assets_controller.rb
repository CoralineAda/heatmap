class RubricCms::ImageAssetsController < ApplicationController

  before_filter :login_required
  before_filter :scope_image_asset, :only => [ :destroy, :edit, :show, :update ]

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges
  end

  # ========================================== Custom ===========================================

  # For TinyMCE
  def image_dialog
    render :layout => false
  end
  
  # ========================================== CRUD ===========================================

  def show
  end

  def new
    @image_asset = ImageAsset.new
  end

  def edit
  end

  def create
    @image_asset = ImageAsset.new(params[:image_asset])

    if @image_asset.save
      flash[:notice] = 'The image was successfully uploaded.'
      redirect_to media_assets_path
    else
      render :action => "new"
    end
  end

  def update
    if @image_asset.update_attributes(params[:image_asset])
      flash[:notice] = 'The image was successfully updated.'
      redirect_to media_assets_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @image_asset.destroy
    redirect_to media_assets_url
  end

  private

  def scope_image_asset
    @image_asset = ImageAsset.find(params[:id])
  end

end

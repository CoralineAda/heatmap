class RubricCms::FlashAssetsController < ApplicationController

  before_filter :login_required
  before_filter :scope_flash_asset, :only => [ :destroy, :edit, :show, :update ]

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges
  end

  # ========================================== CRUD ===========================================

  def index
    render :json => FlashAsset.all.map{|a| {:filename => a.name || a.media.original_filename, :url => a.media.url} }
  end
  
  def show
  end

  def new
    @flash_asset = FlashAsset.new
  end

  def edit
  end

  def create
    @flash_asset = FlashAsset.new(params[:flash_asset])

    if @flash_asset.save
      flash[:notice] = 'The Flash movie was successfully uploaded.'
      redirect_to media_assets_path
    else
      render :action => "new"
    end
  end

  def update
    if @flash_asset.update_attributes(params[:flash_asset])
      flash[:notice] = 'The Flash movie was successfully updated.'
      redirect_to media_assets_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @flash_asset.destroy
    redirect_to media_assets_url
  end

  private

  def scope_flash_asset
    @flash_asset = FlashAsset.find(params[:id])
  end

end

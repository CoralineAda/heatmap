class RubricCms::QuicktimeAssetsController < ApplicationController

  before_filter :login_required
  before_filter :scope_quicktime_asset, :only => [ :destroy, :edit, :show, :update ]

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges
  end

  # ========================================== CRUD ===========================================

  def index
    render :json => QuicktimeAsset.all.map{|a| {:filename => a.name || a.media.original_filename, :url => a.media.url} }
  end

  def show
  end

  def new
    @quicktime_asset = QuicktimeAsset.new
  end

  def edit
  end

  def create
    @quicktime_asset = QuicktimeAsset.new(params[:quicktime_asset])

    if @quicktime_asset.save
      flash[:notice] = 'The Quicktime movie was successfully uploaded.'
      redirect_to media_assets_path
    else
      render :action => "new"
    end
  end

  def update
    if @quicktime_asset.update_attributes(params[:quicktime_asset])
      flash[:notice] = 'The Quicktime movie was successfully updated.'
      redirect_to media_assets_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @quicktime_asset.destroy
    redirect_to media_assets_url
  end

  private

  def scope_quicktime_asset
    @quicktime_asset = QuicktimeAsset.find(params[:id])
  end

end

class RubricCms::PdfAssetsController < ApplicationController

  before_filter :login_required
  before_filter :scope_pdf_asset, :only => [ :destroy, :edit, :show, :update ]

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges
  end

  # ========================================== Custom ===========================================

  # For TinyMCE
  def mce_dialog
    render :layout => false
  end
  
  # ========================================== CRUD ===========================================

  def show
  end

  def new
    @pdf_asset = PdfAsset.new
  end

  def edit
  end

  def create
    @pdf_asset = PdfAsset.new(params[:pdf_asset])

    if @pdf_asset.save
      flash[:notice] = 'The PDF document was successfully uploaded.'
      redirect_to media_assets_path
    else
      render :action => "new"
    end
  end

  def update
    if @pdf_asset.update_attributes(params[:pdf_asset])
      flash[:notice] = 'The PDF document was successfully updated.'
      redirect_to media_assets_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @pdf_asset.destroy
    redirect_to media_assets_url
  end

  private

  def scope_pdf_asset
    @pdf_asset = PdfAsset.find(params[:id])
  end

end

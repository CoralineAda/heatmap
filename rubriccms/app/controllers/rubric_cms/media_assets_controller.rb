class RubricCms::MediaAssetsController < ApplicationController

  before_filter :login_required

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

  def index
    
    # Labels for sort links
    params[:labels] = {
      'media_file_name'     => 'Filename',
      'media_content_type'  => 'Type',
      'media_file_size'     => 'File Size',
      'media_updated_at'    => 'Updated At'
    }
    
    params[:by] ||= :name; params[:dir] ||= 'ASC'

    # Enable filtering
    @filters = MediaAsset::FILTERS
    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      @media_assets = MediaAsset.send(params[:show]).order_by(params[:by], params[:dir]).paginate( :page => params[:page] || 1, :per_page => 50 )
    else
      @media_assets = MediaAsset.all.order_by(params[:by], params[:dir]).paginate( :page => params[:page] || 1, :per_page => 50 )
    end
  end

  private

end

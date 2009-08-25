class RubricCms::SitePagesController < ApplicationController

  audit SitePage

  before_filter :login_required, :except => [ :show ]
  before_filter :scope_public_site_page, :only => [ :show ]
  before_filter :scope_site_page, :only => [ :destroy, :edit, :update ]
  before_filter :scope_site_section, :only => [ :create, :new ]

  # FIXME Set a configuration option for theme_advanced_styles and content_css
  # FIXME Centralize the uses_tiny_cme configuration; survey what types are necessary and turn 'em
  #       into constants
  #
  # Note:
  # Expose CSS classes to the end user by adding them to :theme_advanced_styles
  #
  # Example:
  #   :theme_advanced_styles => "Red=red_text, Blue=blue_text",
  # This adds "Red" and "Blue" to the Styles dropdown; when selected, adds class="red_text"
  #
  # To specify a particular CSS file to use, add it to :content_css
  # Example:
  #   :content_css => '/stylesheets/test.css'
  # This lets you preview the style in real time in the editor.
  uses_tiny_mce :only => [:new, :create, :edit, :update], :options => {
    :mode => "textareas",
    :theme => "advanced",
    :editor_selector => "mceCustom",
    :plugins => %w{ safari style table advimage advlink media pdf visualchars nonbreaking xhtmlxtras  }, # template imagemanager filemanager | insertfile insertimage media
    :extended_valid_elements => "li[value], object[classid|codebase|width|height|align], param[name|value], embed[quality|type|pluginspage|width|height|src|align|wmode]",
    :theme_advanced_buttons1 => %w{ help code attribs cleanup | undo redo removeformat | styleprops bold italic underline strikethrough | bullist numlist | outdent indent blockquote | link unlink anchor image media pdf | hr nonbreaking | charmap advhr cite abbr acronym },
    :theme_advanced_buttons2 => %w{ styleselect formatselect fontselect fontsizeselect | forecolor backcolor | tablecontrols },
    :theme_advanced_buttons3 => %w{  },
    :theme_advanced_toolbar_location => "top",
    :theme_advanced_toolbar_align => "left",
    :theme_advanced_statusbar_location => "bottom",
    :relative_urls => true,
    :document_base_url => "/"
#     :theme_advanced_styles => "Red=red_text, Blue=blue_text",
#     :content_css => '/stylesheets/test.css'
  }

  # ========================================== Overrides ===========================================

  def authorized?
    require_admin_privileges :create, :destroy, :edit, :new, :reorder, :update
  end

  # ============================================ Custom ============================================

  # ============================================ CRUD ============================================

  def show
  end

  def new
    @site_section ||= SiteSection.last
    @site_page = SitePage.new(:user => current_user, :site_section => @site_section)
    @site_page.do_defaults
    @has_published_version = false
  end

  def edit
    @has_published_version = @site_page.published?
    @audit_trail = @site_page.audits
  end

  def create
    @site_page = SitePage.new(params[:site_page])
    @site_page.site_section = SiteSection.find(params[:site_page][:site_section_id])
    @site_page.user = current_user
    @site_section = @site_page.site_section
    
    if params[:commit] == "Preview"
      @site_page.attributes = params[:site_page]
      params[:preview] = true
      render :action => "show", :site_section_id => @site_section
      return
    end
        
    if @site_page.save
      @site_page.reload.publish! if params[:commit] == "Publish"
      flash[:notice] = "The page was successfully #{@site_page.state == 'draft' ? 'saved as a draft.' : 'published.'}"
      redirect_to @site_section
    else
      render :action => "new", :site_section_id => @site_section
    end
  end

  def update
    @site_page.user = current_user
    @site_page.attributes = params[:site_page]

    if params[:commit] == "Preview"
      params[:preview] = true
      render :action => "show", :site_section_id => @site_section
      return
    end
    
    # Saving here instead of updating, so that urls, navbar items, etc. get updated
    # by existing callbacks.
    if @site_page.save
      if params[:commit] == "Publish"
        @site_page.publish! 
      end
      flash[:notice] = "The page was successfully #{@site_page.state == 'draft' ? 'saved as a draft.' : 'published.'}"
      redirect_to @site_section
    else
      render :action => "edit"
    end
  end

  def destroy
    @site_page.destroy
    redirect_to @site_section
  end

  private

  def scope_public_site_page
    if params[:id]
      @site_page = SitePage.published.find(params[:id]) if params[:id]
    elsif params[:url]
      @site_page = SitePage.published.find_by_url("/" << (params[:url] * '/') << "/")
    end
    scope_site_section if @site_page
  end
  
  def scope_site_page
    @site_page = SitePage.find(params[:id])
    scope_site_section
  end
  
  def scope_site_section
    if params[:site_section_id]
      @site_section = SiteSection.find(params[:site_section_id]) 
    elsif @site_page
      @site_section = @site_page.site_section
    end
    @sidebar_items = @site_section && @site_section.sidebar_items ? @site_section.sidebar_items.order_by(:position, 'ASC') : []
  end
end

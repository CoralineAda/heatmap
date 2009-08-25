module RubricCms

  # Extends the application helper with additional methods. Methods in this helper are
  # not namespaced, so they can be overridden in the main app if need be.
  module RubricCmsHelper
  
    # Returns an array of items for use in constructing a breadcrumb. 
    # By default, populated from current @site_page; pass in an array of 
    # items in hash format (or a single item in hash format) with 
    # :name and :url keys to prepend values, or for cases in which there is
    # no @site_page defined.
    #
    # Sample usage:
    #
    #   RubricCms::Site.breadcrumb_items 
    #
    # Returns:
    #
    #   [
    #     {:name => "Home", :url -> "/"},
    #     {:name => "My Site Section", :url => "/foo/"},
    #     {:name => "My Site Page", :url => "/foo/bar/"}
    #   ]
    def breadcrumb_items(*items)
      _breadcrumbs = items if items.is_a?(Array)
      _breadcrumbs = [items] if items.is_a?(Hash)
      _breadcrumbs ||= []
      _breadcrumbs << @site_page.site_section.to_hash if @site_page && @site_page.site_section
      _breadcrumbs.insert(0, {:name => "Home", :url => root_path})
      _breadcrumbs.compact.flatten
    end
    
    # Returns HTML for breadcrumbs. Expects an array of items in hash format with :name
    # and :url keys; defaults to output of breadcrumb_items method.
    def html_for_breadcrumbs(*items)
      _items = breadcrumb_items(items || nil)
      _breadcrumbs = _items.map{|i| %{<a href="#{i[:url]}" title="#{i[:name]}">#{i[:name]}</a>} }
      _breadcrumbs * " &gt; "
    end
  
    # Returns an array of items for use in constructing footer-level links (e.g. links 
    # to copyright pages, contact forms, etc.
    #
    # Sample usage:
    #
    #   footer_navigation_items
    #
    # Returns:
    #
    #   [
    #     {
    #       :name=>"Copyright",
    #       :title=>"View our copyright and terms and conditions.",
    #       :url=>"/copyright/",
    #       :subnav=>[],
    #       :nofollow=>true
    #     },
    #     {
    #       :name=>"About Us",
    #       :title=>"Learn what makes us tick.",
    #       :url=>"/about/",
    #       :subnav=>[],
    #       :nofollow=>false
    #     }
    #   ]
    def footer_navigation_items
      FooterItem.all.map{|i| i.to_hash} || []
    end

    # Returns an array of main site navigation items for use in constructing site navigation controls.
    #
    # Example:
    #
    #   main_navigation_items
    # 
    # Returns:
    # 
    #   [
    #       {
    #         :name => "Ruby on Rails",
    #         :title => "Ruby on Rails",
    #         :url => "/ruby_on_rails/",
    #         :nofollow => false,
    #         :subnav => [
    #           {
    #             :name => "More RoR Stuff"
    #             :title => "More RoR Stuff",
    #             :url => "/ruby_on_rails/more/"
    #             :nofollow => true,
    #             :subnav => [],
    #           },
    #           {
    #             :name => "Some Rails Links"
    #             :title => "Explore More",
    #             :url => "/ruby_on_rails/links/"
    #             :nofollow => false,
    #             :subnav => [],
    #           }
    #         ]
    #       },
    #       {
    #         :name => "CMS Admin",
    #         :title => "Manage Site Content with Rubric CMS",
    #         :url => "/rubric_cms_admin/"
    #         :nofollow => true,
    #       }
    #   ]
    def main_navigation_items
      _main = NavbarItem.top_level.map{|i| i.to_hash}.sort{|a,b| a[:position].to_i <=> b[:position].to_i}
      _main << {:name => 'CMS Admin', :title => 'Manage Site Content with Rubric CMS', :url => '/rubric_cms_admin/', :nofollow => true}
      _main
    end

    # Returns the meta keywords or description for the current site page, site section, or default 
    # from the site, in that order of precendence.
    #
    # You can also force the content by calling the method with a second argument.
    #
    # Sample usage:
    #
    #   <%= meta_tag_for(:description) -%>
    #   <%= meta_tag_for(:keywords, "foo, bar, trouble") -%>
    #
    # Returns:
    #
    #   <meta name="description" content="<%= yield(:meta_description) || meta_tag_content(:description) -%>" />
    #   <meta name="keywords" content="<%= yield(:meta_keywords) || meta_tag_content(:keywords) -%>" />
    #
    def meta_tag_content(which, content=nil)
      if which == :description
        if @site_page && @site_page.meta_description
          _content = @site_page.meta_description
        elsif @site_page && @site_page.site_section && @site_page.site_section.default_meta_description
          _content = @site_page.site_section.default_meta_description
        else
          _content = SiteConfiguration.default_meta_description || RubricCms::Config.default_meta_description
        end
        content_for(RubricCms::Config.meta_description_placeholder) { content || _content }
      elsif which == :keywords
        content = content * ", " if content.is_a?(Array)
        if @site_page && @site_page.meta_keywords
          _content = @site_page.meta_keywords
        elsif @site_page && @site_page.site_section && @site_page.site_section.default_meta_keywords
          _content = @site_page.site_section.default_meta_keywords
        else
          _content = SiteConfiguration.default_meta_keywords || RubricCms::Config.default_meta_keywords
        end
        content_for(RubricCms::Config.meta_keywords_placeholder) { content || _content }
      end
      content || _content
    end
    
    # Returns a collection of <option> tags for the specified type of 
    # media assets that have been loaded into the system.
    # Used internally in the TinyMCE WYSIWYG editor.
    def options_for_media_assets(type)
      case type
      when :flash
        _collection = FlashAsset.all
      when :image
        _collection = ImageAsset.all
      when :pdf
        _collection = PdfAsset.all
      when :quicktime
        _collection = QuicktimeAsset.all
      end
      return unless _collection
      _html = %{<option value="">Select...</option>}
      _collection.each do |i|
        if i.media.url
          _name = i.name || i.media.original_filename
          _html << %{<option value="#{i.media.url}">#{_name}</option>}
        end
      end
      _html
    end
    
    # Return sidebar items for the current site section.
    def sidebar_navigation_items
      _sidebar = []
      if @site_page.site_section && @site_page.site_section.sidebar_enabled?
        _sidebar = @site_page.site_section.sidebar_items.map{|i| i.to_hash}.sort{|a,b| a[:position].to_i <=> b[:position].to_i}
      end
      _sidebar
    end
   
    # Creates a tag for displaying Flash content inline on a web page.    
    def tag_for_flash(flash_asset)
      %{<a href="#{flash_asset.media.url}" class="lightview">Click to view '#{flash_asset.name}'</a>}
    end
    
    # FIXME Add flags for displaying preview image, PDF icon
    # Creates a link for downloading a PDF asset.    
    def tag_for_pdf(pdf_asset)
      %{
        <a href="#{pdf_asset.media.url}" title="Download '#{pdf_asset.name}' in PDF format">#{pdf_asset.media_file_name}</a> (#{number_to_human_size(pdf_asset.media_file_size.to_f)} PDF)
        <a href="#{pdf_asset.media.url}" title="Download '#{pdf_asset.name}' in PDF format"><img src="/images/icons/pdficon_small.gif" alt="PDF" style="margin: 0px 5px;"></a>
      }
    end
    
    # Creates a tag for displaying Quicktime content inline on a web page.    
    def tag_for_quicktime(quicktime_asset)
      %{
        <object classid='clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B' width="320" height="255" codebase='http://www.apple.com/qtactivex/qtplugin.cab'>
          <param name='src' value="#{quicktime_asset.media.url}">
          <param name='autoplay' value="true">
          <param name='controller' value="true">
          <param name='loop' value="true">
          <embed src="#{quicktime_asset.media.url}" width="320" height="255" autoplay="false" 
          controller="true" loop="false" pluginspage='http://www.apple.com/quicktime/download/'>
          </embed>
        </object>
      }
    end
  
    # If you use content_for in your layouts to define the window title and page title,
    # use this method to populate your placeholders.
    #
    # By default, this method will populate placeholders identified by :window_title and
    # :page_title. To customize the names of these placeholders, modify the values in 
    # config/rubric_cms.rb in your application's config directory.
    #
    # Example (in application.html.erb):
    #
    #   <title><%= yield(:window_title) -%></title>
    #   ...
    #   <body>
    #   <h1><%= yield(:page_title) -%></h1>
    #
    # To use this method outside of the CMS, add this to the top of your views:
    #
    #   <%- title_content 'My Page Title Here' -%>
    # 
    def title_content(title=nil)
      _slug = []
      if title
        _slug << title
      elsif @site_page
        _slug << @site_page.page_title unless @site_page.root_page?
        _slug << @site_section.name if RubricCms::Config.include_site_section_in_window_title && @site_page.site_section
        _slug.delete_if{|i| i.to_s.empty? }.flatten!
      end
      _slug << SiteConfiguration.site_name || RubricCms::Config.site_name
      _window_title = _slug * RubricCms::Config.window_title_separator
      _page_title = _slug[0]
      content_for(RubricCms::Config.window_title_placeholder) { _window_title }
      content_for(RubricCms::Config.page_title_placeholder) { _page_title }
      {:window_title => _window_title, :page_title => _page_title}
    end

    # This method can be called to distinguish between requests for standard Rails 
    # application pages and pages managed by the CMS.
    def viewing_a_site_page?
      controller?('site_pages') && action?(/show/)
    end

  end
end


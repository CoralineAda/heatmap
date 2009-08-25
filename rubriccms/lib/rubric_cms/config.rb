module RubricCms

  # Defines configuration options for RubricCms. See RubricCms::Config for details.
  #
  # == Configuration options for RubricCms
  #
  # The RubricCms config file (rubric_cms.rb) is copied to your application's config directory
  # on installation of the plugin. The options below are set by modifying that file.
  #
  # === meta_description_placeholder
  #
  # In your application layout file, the name of the placeholder for
  # the meta description tag content. In the example below, :meta_description is the name of
  # this placeholder:
  # 
  #     <meta name="description" content="<%= yield(:meta_description) || meta_tag_content(:description) -%>" />
  #  
  # === meta_keywords_placeholder
  #
  # In your application layout file, the name of the placeholder for
  # the meta keywords tag content. In the example below, :meta_keywords is the name of
  # this placeholder:
  # 
  #     <meta name="keywords" content="<%= yield(:meta_keywords) || meta_tag_content(:keywords) -%>" />
  #  
  # === site_name
  #
  # The name of your site, as it should appear in window titles
  # 
  # === page_title_placeholder
  #
  # In your application layout file, the name of the placeholder for
  # the page title. In the example below, :page_title is the name of
  # this placeholder:
  #
  #     <body>
  #		  <h1><%= yield(:page_title) || title_content[:page_title] -%></h1>
  # 
  # === window_title_placeholder
  #
  # In your application layout file, the name of the placeholder for
  # the window title. In the example below, :window_title is the name of
  # this placeholder:
  #
  #     <head>
  #   	  <title><%= yield(:window_title) || title_content[:window_title] -%></title>
  #     ...
  #     </head>
  #
  # === window_title_separator
  #
  # Specifies the character (or string) that should be used to separate
  # elements in your window title. For example, specifying ": " would
  # result in window titles like this:
  #
  #     <title>Foo Page: My Application</title>
  #
  # === include_site_section_in_window_title
  #
  # Specifies whether the name of the current page's site section be included in the
  # window title slug.
  #
  # Example when set to true:
  #
  #     <title>My Page - My Application</title>
  #
  # Example when set to false:
  #
  #     <title>My Page - My Section - My Application</title>
  #
  # === default_meta_description
  #
  # Set the default meta description that should be used when the meta
  # description is not set for a given page.
  #
  # === default_meta_keywords
  #
  # Set the default keywords that should be used when the meta
  # keywords are not set for a given page.
  #
  # === maximum_file_size_for_flash_asset
  #
  # Set the maximum file size (in MB) for Flash assets.
  #
  # === maximum_file_size_for_image_asset
  #
  # Set the maximum file size (in MB) for image assets.
  #
  # === maximum_file_size_for_pdf_asset
  #
  # Set the maximum file size (in MB) for PDF assets.
  #
  # === maximum_file_size_for_quicktime_asset
  #
  # Set the maximum file size (in MB) for Quicktime assets.
  #
  class Config
    @options = {
      'default_meta_description' => '',
      'default_meta_keywords' => 'test,flood',
      'include_site_section_in_window_title' => true,
      'maximum_file_size_for_flash_asset' => 15,
      'maximum_file_size_for_image_asset' => 5,
      'maximum_file_size_for_pdf_asset' => 20,
      'maximum_file_size_for_quicktime_asset' => 15,
      'meta_keywords_placeholder' => :meta_keywords,
      'meta_description_placeholder' => :meta_description,
      'page_title_placeholder' => :page_title,
      'site_name' => "Your Application",
      'window_title_placeholder' => :window_title,
      'window_title_separator' => ' - '
    }
    method_declarations = ""
    @options.keys.each do |m|
      method_declarations << %{
        def self.#{m.to_s}
          @options['#{m}']
        end
        def self.#{m.to_s}=(value)
          @options['#{m}'] = value
        end
      }
    end
    eval method_declarations
  end
end

Module RubricCms

  # Configuration options for RubricCms
  
  # In your application layout file, the name of the placeholder for
  # the meta description tag content. In the example below, :meta_description is the name of
  # this placeholder:
  #
  #   <head>
  #   <meta name="keywords" content="<%= yield(:meta_keywords) || '' -%>" />
  #   ...
  #
  RubricCms::Config.meta_keywords_placeholder = :meta_keywords
  
  # In your application layout file, the name of the placeholder for
  # the meta description tag content. In the example below, :meta_description is the name of
  # this placeholder:
  #
  #   <head>
  #   <meta name="description" content="<%= yield(:meta_description) || '' -%>" />
  #   ...
  #
  RubricCms::Config.meta_description_placeholder = :meta_description
  
  # In your application layout file, the name of the placeholder for
  # the page title. In the example below, :page_title is the name of
  # this placeholder:
  #
  #   <body>
  #   <h1><%= yield(:page_title) -%></h1>
  # 
  RubricCms::Config.page_title_placeholder = :page_title
  
  # In your application layout file, the name of the placeholder for
  # the page title. In the example below, :page_title is the name of
  # this placeholder:
  #
  #   <body>
  #   <h1><%= yield(:page_title) -%></h1>
  # 
  RubricCms::Config.page_title_placeholder = :page_title
  
  # In your application layout file, the name of the placeholder for
  # the window title. In the example below, :window_title is the name of
  # this placeholder:
  #
  #   <title><%= yield(:window_title) -%></title>
  #   ...
  #   <body>
  #
  RubricCms::Config.window_title_placeholder = :window_title
  
  # Specify the character (or string) that should be used to separate
  # elements in your window title. For example, specifying ": " would
  # result in window titles like this:
  #
  #   <title>Foo Page: My Application</title>
  #
  RubricCms::Config.window_title_separator = ' - '

end
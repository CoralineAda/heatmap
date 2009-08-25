# Loads routes required for the operation of RubricCMS from 
# rubric_cms/config/rubric_cms_routes.rb.
#
# Unlike most Rails engines, the enclosing application's routes will be
# loaded first.
#
# Note that if you have a catch-all route defined, you may experience a conflict.
if defined?(ActionController::Routing::RouteSet)
  module ActionController #:nodoc:
    module Routing #:nodoc:
      class RouteSet #:nodoc:
        def load_routes_with_rubric_cms!
          lib_path = File.dirname(__FILE__)
          rubric_cms_routes = File.join(lib_path, *%w[.. .. config rubric_cms_routes.rb])
          unless configuration_files.include?(rubric_cms_routes)
            add_configuration_file(rubric_cms_routes)
          end
          load_routes_without_rubric_cms!
        end
        alias_method_chain :load_routes!, :rubric_cms
      end
    end
  end
end
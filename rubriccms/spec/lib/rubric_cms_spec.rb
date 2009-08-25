require File.dirname(__FILE__) + '/../spec_helper'
require 'lib/rubric_cms/config'
require 'lib/rubric_cms/base'
require 'lib/rubric_cms/routes'

describe RubricCms do
  
  it 'should default to using CRUD icons' do
    RubricCms.use_crud_icons.should be_true
  end
  
  describe Site do
  
    describe 'defaults to values defined in config.rb' do
    
      before do
        SiteConfiguration.destroy_all
      end
      
      ['default_meta_description', 'default_meta_keywords', 'site_name'].each do |p|
        it "returns a default value for #{p}" do
          RubricCms::Site.send(p.to_sym).should == RubricCms::Config.send(p.to_sym)
        end
      end
    
    end
    
    describe 'uses values defined in the active, databased site configuration' do
    
      before do
        SiteConfiguration.destroy_all
        @config = SiteConfiguration.make
      end

      ['default_meta_description', 'default_meta_keywords', 'site_name'].each do |p|
        it "returns the correct value for #{p}" do
          RubricCms::Site.send(p.to_sym).should == @config.send(p.to_sym)
        end
      end
      
    end

  end
  
  describe Config do

    describe 'creates getters and setters for configuration options' do
    
      ['default_meta_description', 'default_meta_keywords', 'include_site_section_in_window_title', 'meta_description_placeholder', 'meta_keywords_placeholder', 'page_title_placeholder', 'site_name', 'window_title_placeholder', 'window_title_separator', 'maximum_file_size_for_flash_asset', 'maximum_file_size_for_image_asset', 'maximum_file_size_for_pdf_asset', 'maximum_file_size_for_quicktime_asset'].each do |p|
        it "gets a value for #{p}" do
          RubricCms::Config.send(p).should_not be_nil
        end

        it "sets a value for #{p}" do
          _new_value = nil
          if RubricCms::Config.send(p.to_sym).is_a?(Integer)
            _new_value = 13
            eval("RubricCms::Config.#{p} = #{_new_value}")
          elsif RubricCms::Config.send(p.to_sym).is_a?(TrueClass) || RubricCms::Config.send(p.to_sym).is_a?(FalseClass)
            _new_value = ! RubricCms::Config.send(p.to_sym)
            eval("RubricCms::Config.#{p} = #{_new_value}")
          elsif RubricCms::Config.send(p.to_sym).is_a?(Float)
            _new_value = 13.0
            eval("RubricCms::Config.#{p} = #{_new_value}")
          elsif RubricCms::Config.send(p.to_sym).is_a?(String)
            _new_value = "#{Faker::Lorem.words(1)}"
            eval("RubricCms::Config.#{p} = '#{_new_value}'")
          elsif RubricCms::Config.send(p.to_sym).is_a?(Symbol)
            _new_value = "#{Faker::Lorem.words(1).to_s}".to_sym
            eval("RubricCms::Config.#{p} = :#{_new_value}")
          end
          RubricCms::Config.send(p.to_sym).should == _new_value
        end

      end
      
    end
  
  end
end
